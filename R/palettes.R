#' Carga el JSON de colores Wada Sanzo desde archivo local o remoto
#'
#' Primero intenta cargar desde archivo local `wada_colores.json` en
#' `inst/extdata/`. Si falla o no existe, descarga desde la URL y guarda localmente.
#'
#' @param path_local Ruta local del archivo JSON (por defecto en extdata del paquete)
#' @param url URL del JSON remoto
#' @return Lista con los colores
.cargar_colores_wada <- function(
    path_local = system.file("extdata", "wada_colores.json", package = "wadaPalettes"),
    url = "https://sanzo-wada.dmbk.io/assets/colors.json"
) {
  if (file.exists(path_local)) {
    tryCatch({
      json <- jsonlite::fromJSON(path_local)
      message("Archivo local cargado desde: ", path_local)
      return(json)
    }, error = function(e) {
      warning("Error leyendo archivo local, intentando descargar...")
    })
  }

  tryCatch({
    res <- httr::GET(url)
    httr::stop_for_status(res)
    json <- jsonlite::fromJSON(rawToChar(res$content))
    dir_local <- dirname(path_local)
    if (!dir.exists(dir_local)) dir.create(dir_local, recursive = TRUE)
    jsonlite::write_json(json, path_local, pretty = TRUE)
    message("Archivo descargado y guardado en: ", path_local)
    return(json)
  }, error = function(e) {
    stop("No se pudo cargar el archivo JSON local ni remoto.")
  })
}

#' Prepara el diccionario de combinaciones a partir del JSON
#'
#' @param json Lista con datos crudos del JSON
#' @return Dataframe con combinaciones y sus colores hex
.preparar_diccionario_combinaciones <- function(json) {
  # colores_df <- tibble::tibble(
  #   id_color = sapply(json, `[[`, "index"),
  #   nombre = sapply(json, `[[`, "name"),
  #   hex = sapply(json, `[[`, "hex"),
  #   combinaciones = lapply(json, `[[`, "combinations")
  # )
  #
  # combinaciones_df <- colores_df |>
  #   tidyr::unnest_longer(combinaciones) |>
  #   dplyr::rename(id_comb = combinaciones)
  #
  # diccionario <- combinaciones_df |>
  #   dplyr::group_by(id_comb) |>
  #   dplyr::summarise(
  #     colores_hex = list(hex),
  #     nombres = list(nombre),
  #     .groups = "drop"
  #   )

  # Extraer columnas relevantes

  # Convertir a data frame
  colores_df <- as.data.frame(json)


  colores_df <- colores_df |>
    dplyr::mutate(
      id_color = colors.index,
      combinaciones = purrr::map(colors.combinations, as.character),
      hex = as.character(colors.hex),
      nombre = as.character(colors.name)
    ) |>
    dplyr::select(id_color, nombre, hex, combinaciones)


  # Expandir todas las combinaciones como (id_comb, id_color)
  combinaciones_df <- colores_df |>
    dplyr::select(id_color, combinaciones) |>
    tidyr::unnest(combinaciones) |>
    dplyr::rename(id_comb = combinaciones)

  # Agrupar por combinación
  diccionario <- combinaciones_df |>
    dplyr::left_join(colores_df, by = "id_color") |>
    dplyr::group_by(id_comb) |>
    dplyr::summarise(
      colores_hex = list(hex),
      nombres = list(nombre),
      .groups = "drop"
    )

  return(diccionario)
}

# Environment para cache
.wada_env <- new.env(parent = emptyenv())

#' Obtiene los colores y nombres de una combinación Wada Sanzo
#'
#' @param id_combinacion Número o carácter con el ID de combinación
#' @return Lista con elementos `colores` (vector HEX) y `nombres` (vector de nombres)
#' @export
obtener_combinacion_wada <- function(id_combinacion) {
  if (!exists("diccionario", envir = .wada_env)) {
    json <- .cargar_colores_wada()
    .wada_env$diccionario <- .preparar_diccionario_combinaciones(json)
  }

  dicc <- .wada_env$diccionario
  id_str <- as.character(id_combinacion)

  fila <- dicc |> dplyr::filter(id_comb == id_str)
  if (nrow(fila) == 0) stop("Combinación no encontrada: ", id_str)

  # list(
  #   colores = fila$colores_hex[[1]],
  #   nombres = fila$nombres[[1]]
  # )

  return(list(
    combinacion = id_combinacion,
    colores = fila$colores_hex[[1]],
    nombres = fila$nombres[[1]]
  ))

}

#' Crea una paleta interpolada basada en combinación Wada Sanzo
#'
#' @param id Número o carácter con el ID de combinación
#' @param n Número de colores a generar (por defecto 6)
#' @return Vector de colores HEX interpolados
#' @export
crear_paleta_colores <- function(id, n = 6) {
  colores <- obtener_combinacion_wada(id)$colores
  grDevices::colorRampPalette(colores)(n)
}
