






## Visualización de ejemplos con `ggplot2`

### 1. Gráfico de barras


ggplot(mpg, aes(class, fill = class)) +
  geom_bar() +
  scale_fill_manual(values = crear_paleta_colores(314, (length(unique(mpg$class))))) +
  theme_minimal() +
  labs(title = "Gráfico de barras con paleta Wada 231")

ggsave("inst/gallery/barras_231.png", width = 6, height = 4)

### 2. Columnas apiladas


ggplot(mpg, aes(x = manufacturer, fill = class)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = crear_paleta_colores(50, (length(unique(mpg$class))))) +
  theme_minimal() +
  labs(title = "Columnas apiladas con paleta Wada 50") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("inst/gallery/columnas_apiladas_50.png", width = 6, height = 4)

### 3. Scatter plot


ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 3) +
  scale_color_manual(values = crear_paleta_colores(235, (length(unique(mpg$class))))) +
  theme_minimal() +
  labs(title = "Scatter plot con paleta Wada 235")

ggsave("inst/gallery/dispersión_235.png", width = 6, height = 4)

### 4. Boxplot


ggplot(mpg, aes(x = class, y = hwy, fill = class)) +
  geom_boxplot() +
  scale_fill_manual(values = crear_paleta_colores(300, (length(unique(mpg$class))))) +
  theme_minimal() +
  labs(title = "Boxplot con paleta Wada 300")

ggsave("inst/gallery/boxplot_300.png", width = 6, height = 4)

### 5. Área


if (requireNamespace("ggplot2", quietly = TRUE)) {
  ggplot(economics_long, aes(x = date, y = value01, fill = variable)) +
    geom_area() +
    scale_fill_manual(values = crear_paleta_colores(250, (length(unique(economics_long$variable))))) +
    theme_minimal() +
    labs(title = "Área con paleta Wada 250")
}

ggsave("inst/gallery/área_250.png", width = 6, height = 4)

### 6. Líneas


if (requireNamespace("ggplot2", quietly = TRUE)) {
  ggplot(economics_long, aes(x = date, y = value01, color = variable)) +
    geom_line(size = 1.2) +
    scale_color_manual(values = crear_paleta_colores(175, (length(unique(economics_long$variable))))) +
    theme_minimal() +
    labs(title = "Líneas con paleta Wada 175")
}

ggsave("inst/gallery/líneas_175.png", width = 6, height = 4)





# Cargar librerías necesarias
library(ggplot2)
library(dplyr)
library(wadaPalettes) # tu paquete debe estar cargado

# Crear vector de combinaciones a usar
combinaciones <- c(273, 277, 264, 9, 325, 348, 313, 272, 330, 333, 347, 55, 344)

# Directorio de salida
dir.create("inst/gallery", showWarnings = FALSE, recursive = TRUE)

# Función para generar y guardar gráficos
generar_graficos_wada <- function(id) {
  colores <- crear_paleta_colores(id, 5)

  # Datos de ejemplo comunes
  df_bar <- data.frame(grupo = letters[1:5], valor = sample(1:100, 5))
  df_bar_apilado <- tidyr::expand_grid(grupo = letters[1:3], categoria = c("A", "B", "C")) %>%
    mutate(valor = sample(1:50, 9))
  df_disp <- data.frame(x = rnorm(100), y = rnorm(100), grupo = sample(letters[1:5], 100, TRUE))
  df_line <- data.frame(x = 1:10, y = cumsum(rnorm(10)), grupo = rep(letters[1:5], each = 2))
  df_box <- data.frame(valor = rnorm(100), grupo = sample(letters[1:5], 100, TRUE))
  df_area <- data.frame(x = 1:10, y = cumsum(runif(10, 0, 1)), grupo = "Serie")

  # Gráfico de barras
  g1 <- ggplot(df_bar, aes(x = grupo, y = valor, fill = grupo)) +
    geom_col() +
    scale_fill_manual(values = colores) +
    theme_minimal() +
    labs(title = paste("Barras", id))
  ggsave(sprintf("inst/gallery/barras_%s.png", id), g1, width = 6, height = 4)

  # Columnas apiladas
  g2 <- ggplot(df_bar_apilado, aes(x = grupo, y = valor, fill = categoria)) +
    geom_col(position = "stack") +
    scale_fill_manual(values = colores) +
    theme_minimal() +
    labs(title = paste("Columnas Apiladas", id))
  ggsave(sprintf("inst/gallery/columnas_apiladas_%s.png", id), g2, width = 6, height = 4)

  # Dispersión
  g3 <- ggplot(df_disp, aes(x = x, y = y, color = grupo)) +
    geom_point() +
    scale_color_manual(values = colores) +
    theme_minimal() +
    labs(title = paste("Dispersión", id))
  ggsave(sprintf("inst/gallery/dispersion_%s.png", id), g3, width = 6, height = 4)

  # Líneas
  g4 <- ggplot(df_line, aes(x = x, y = y, color = grupo, group = grupo)) +
    geom_line() +
    scale_color_manual(values = colores) +
    theme_minimal() +
    labs(title = paste("Líneas", id))
  ggsave(sprintf("inst/gallery/lineas_%s.png", id), g4, width = 6, height = 4)

  # Boxplot
  g5 <- ggplot(df_box, aes(x = grupo, y = valor, fill = grupo)) +
    geom_boxplot() +
    scale_fill_manual(values = colores) +
    theme_minimal() +
    labs(title = paste("Boxplot", id))
  ggsave(sprintf("inst/gallery/boxplot_%s.png", id), g5, width = 6, height = 4)

  # Área
  g6 <- ggplot(df_area, aes(x = x, y = y, fill = grupo)) +
    geom_area() +
    scale_fill_manual(values = colores[1]) +
    theme_minimal() +
    labs(title = paste("Área", id))
  ggsave(sprintf("inst/gallery/area_%s.png", id), g6, width = 6, height = 4)
}

# Generar gráficos para cada combinación
purrr::walk(combinaciones, generar_graficos_wada)







