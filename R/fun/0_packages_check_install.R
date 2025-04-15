## ---------------------------------------------------------------
## Instalação dos pacotes usados no script
## ---------------------------------------------------------------

# Lista de pacotes que estão no CRAN
cran_pkgs <- c(
  "raster", "ggplot2", "ggthemes", "sf", "data.table", "geobr",
  "pbapply", "readr", "tidyr", "stringr", "lubridate", "fasttime",
  "mapview", "RColorBrewer", "extrafont", "knitr", "furrr", "purrr",
  "forcats", "future.apply", "dplyr", "hrbrthemes", "beepr",
  "patchwork", "Hmisc", "osmdata", "opentripplanner", "ggmap",
  "bit64", "quantreg", "gtfstools"
)

# Função simples para instalar apenas o que ainda não está instalado
install_if_missing <- function(pkgs) {
  missing_pkgs <- setdiff(pkgs, rownames(installed.packages()))
  if (length(missing_pkgs)) install.packages(missing_pkgs)
}

install_if_missing(cran_pkgs)

# ----------------------------------------------------------------
# Pacote que não está no CRAN (h3jsr) – instalar via GitHub
# ----------------------------------------------------------------
if (!requireNamespace("h3jsr", quietly = TRUE)) {
  install_if_missing("remotes")              # garante que 'remotes' exista
  remotes::install_github("obrl-soil/h3jsr") # instala h3jsr
}

# 1) garante que o helper 'remotes' esteja presente
install.packages("remotes")

# 2) instala a versão 0.6-4 diretamente do arquivo de archive do CRAN
remotes::install_version(
  "rgeos",
  version = "0.6-4",
  repos   = "https://cran.r-project.org"
)

remotes::install_version(
  "maptools",
  version = "1.1-8",
  repos   = "https://cran.r-project.org"
)