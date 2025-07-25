
library(wadaPalettes)

# Función para guardar imagen de una paleta
guardar_imagen_paleta <- function(paleta_id, n = NULL, carpeta = "inst/extdata") {
  colores <- crear_paleta_colores(paleta_id, n)
  n_col <- length(colores)
  archivo <- file.path(carpeta, paste0("paleta_", paleta_id, ".png"))

  png(archivo, width = 300, height = 100)
  par(mar = c(0, 0, 0, 0))
  barplot(rep(1, n_col), col = colores, border = NA, space = 0, axes = FALSE)
  title(main = paste("Paleta Wada", paleta_id), line = -1.5, cex.main = 1.5)
  dev.off()
  message("Guardado: ", archivo)
}

# Ejemplo: generar imágenes para estas paletas
paletas_ejemplo <- c(50, 331, 335, 342)

for (pid in paletas_ejemplo) {
  guardar_imagen_paleta(pid, n = 5)
}
