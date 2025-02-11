library(colorspace)
library(tidyverse)
library(showtext)
library(ggplot2)

# peguei as cores do site e criei um vetor com nomes fáceis de lembrar
cores_dadosjusbr <- c(
  lilas = "#B361C6",
  cyan = "#2FBB96",
  cinza_azulado = "#3e5363",
  verde = "#96ba2f",
  laranja = "#F2C94C",
  cinza_claro = "#F5F5F5"
)

#' Paleta de cores Transparência Brasil
cores_tb <- c(
  laranja = "#F6A323",
  cinza_escuro = "#1d1d1b",
  cinza_claro = "#6f7171",
  cinza_quase_branco = "#ececec",
  azul = "#41ACBD",
  vermelho_tadepe = "#7d1611",
  azul_tadepe = "#124C7D",
  verde_mais_defensoria = "#10624E"
)

#' Paleta de cores Achados e pedidos
cores_aep <- c(
  laranja = "#fcaa27",
  rosa = "#D81755",
  vermelho = "#F03034",
  cinza = "#969696",
  marrom = "#B27D5C"
)

## Loading Google fonts (https://fonts.google.com/)
font_add_google("Open Sans", "open")

## Automatically use showtext to render text
showtext_auto()
showtext_opts(dpi = 250)
theme_set(hrbrthemes::theme_ipsum_rc(
  base_family = "sans",
  subtitle_family = "sans",
  caption_family = "sans"
))


theme_update(
  base_size = 11.5,
  panel.grid.minor = element_blank(),
  panel.background = element_rect(fill = "gray97", color = "transparent"),
  axis.line.y = element_blank(),
  axis.line.x = element_blank(), # element_line(color = "gray30"),
  axis.title = ggtext::element_markdown(hjust = .5, size = 10.5),
  axis.title.x = ggtext::element_markdown(hjust = .5, size = 10.5),
  axis.title.x.top = ggtext::element_markdown(hjust = .5, size = 10.5),
  axis.title.x.bottom = ggtext::element_markdown(hjust = .5, size = 10.5),
  axis.title.y = ggtext::element_markdown(hjust = .5, size = 10.5),
  axis.title.y.left = ggtext::element_markdown(hjust = .5, size = 10.5),
  axis.title.y.right = ggtext::element_markdown(hjust = .5, size = 10.5),
  axis.text = ggtext::element_markdown(size = 10.5),
  axis.text.x = ggtext::element_markdown(size = 10.5),
  axis.text.x.top = ggtext::element_markdown(size = 10.5),
  axis.text.x.bottom = ggtext::element_markdown(size = 10.5),
  axis.text.y = ggtext::element_markdown(size = 10.5),
  axis.text.y.left = ggtext::element_markdown(size = 10.5),
  axis.text.y.right = ggtext::element_markdown(size = 10.5),
  legend.text = ggtext::element_markdown(size = 10.5),
  legend.title = ggtext::element_markdown(),
  plot.title.position = "plot",
  plot.title = ggtext::element_markdown(size = 14),
  plot.subtitle = ggtext::element_markdown(size = 12, hjust = 0, color = cores_tb[["cinza_claro"]]),
  plot.caption = ggtext::element_markdown(size = 9, color = cores_tb[["cinza_claro"]]),
  plot.tag = ggtext::element_markdown(),
  strip.text = ggtext::element_markdown(size = 10.5, hjust = .5),
  strip.text.x = ggtext::element_markdown(),
  strip.text.x.bottom = ggtext::element_markdown(),
  strip.text.x.top = ggtext::element_markdown(),
  strip.text.y = ggtext::element_markdown(),
  strip.text.y.left = ggtext::element_markdown(),
  strip.text.y.right = ggtext::element_markdown(),
  panel.grid.major.x = element_blank(),
  panel.grid.major.y = element_line(color = "gray80", linewidth = .1)
)

hrbrthemes::update_geom_font_defaults(
  # color = "gray30",
  family = "Roboto Condensed"
)

# helper functions:

# funções auxiliares
# Formata números em valor monetário no padrão BRL: 12345.6 --> R$ 1.2345,60
reais <- function(...) scales::dollar(..., big.mark = ".", decimal.mark = ",", prefix = "R$ ")
# Formata números inteiros: 12345 --> 1.2345
numero <- function(...) scales::number(..., big.mark = ".", decimal.mark = ",")
perc <- function(...) scales::percent(..., big.mark = ".", decimal.mark = ",")

# Formata números nas tabelas do pacote gt::gt()

# Dinheiro
fmt_currency_brl <- function(...) {
  gt::fmt_currency(
    ...,
    sep_mark = ".",
    dec_mark = ",",
    currency = "BRL"
  )
}

# Percentual
fmt_percent_brl <- function(...) {
  gt::fmt_percent(
    ...,
    sep_mark = ".",
    dec_mark = ","
  )
}

# Números inteiros
fmt_number_brl <- function(...) {
  gt::fmt_number(
    ...,
    sep_mark = ".",
    dec_mark = ","
  )
}