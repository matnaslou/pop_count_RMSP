library(geobr)   # shapes oficiais do IBGE
library(sf)
library(dplyr)
library(purrr)

calc_ratio <- function(code_muni, year = 2020) {
  muni <- read_municipality(code_muni = code_muni, year = year) |>
    st_transform(3857)                # unidades em metros
  bb   <- st_bbox(muni)
  ratio <- (bb["xmax"] - bb["xmin"]) /
    (bb["ymax"] - bb["ymin"])
  print(str(muni$code_muni),str(muni$name_muni),str(round(as.numeric(ratio), 2)))               # arredonda a 2 casas
}

# Exemplo: Pelotas‑RS e Santos‑SP
tibble(code_muni = c(3503901, 3505708,3506607,3509007,3509205,3510609,3513009,3513801,
                     3515004,3515707,3516309,3516408,3518305,3518800,3522208,3522505,
                     3523107,3525003,3526209,3528502,3529401,3530607,3534401,3539103,
                     3539806,3543303,3544103,3545001,3546801,3547304,3547809,3548708,
                     3548807,3549953,3552502,3552809,3556453),
       map_plot_ratio_wh = map_dbl(code_muni, calc_ratio))
