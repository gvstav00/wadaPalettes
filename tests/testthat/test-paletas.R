library(testthat)
library(wadaPalettes)

# test_that("obtener_combinacion_wada devuelve lista con colores y nombres", {
#   resultado <- obtener_combinacion_wada(335)
#   expect_type(resultado, "list")
#   expect_named(resultado, c("colores", "nombres"))
#
#   # Los colores deben ser cadenas hex (empiezan con #)
#   expect_true(all(grepl("^#", resultado$colores)))
#   # Al menos un color en la lista
#   expect_gt(length(resultado$colores), 0)
# })

test_that("obtener_combinacion_wada devuelve lista con colores y nombres", {
  resultado <- obtener_combinacion_wada(335)
  expect_type(resultado, "list")
  # Cambiar la expectativa para que incluya 'combinacion' también
  expect_true(all(c("colores", "nombres") %in% names(resultado)))

  # Validar que colores son hex
  expect_true(all(grepl("^#", resultado$colores)))
  expect_gt(length(resultado$colores), 0)
})



test_that("crear_paleta_colores genera vector de colores de tamaño n", {
  n_colores <- 7
  paleta <- crear_paleta_colores(335, n = n_colores)

  expect_type(paleta, "character")
  expect_length(paleta, n_colores)
  expect_true(all(grepl("^#", paleta)))  # todos deben ser hex
})

test_that("obtener_combinacion_wada lanza error para combinación inexistente", {
  expect_error(obtener_combinacion_wada(999999), "Combinación no encontrada")
})
