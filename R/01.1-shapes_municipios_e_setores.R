#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
###### 0.1.1 Download de shape file de municipios e setores censitarios dos  municipios incluidos no projeto
# Esse script faz o download do shape dos municipios e setores censitarios do pacote geobr,
# e salva-os na pasta de data-raw
# Por mais que os shapes nao mudem entre os anos, eles sao salvos em pastas separadas para cada um dos anos
# Isso em geral causa multiplicacao de shapes para a maioria das cidades, mas algumas cidades podem aprensetar
# mudanca no seu shape (goiania p/ 2019, por exemplo, q considera a RM) e portanto devem ser consideradas

# carregar bibliotecas
source('./R/fun/setup.R')
# função do geobr para dissolver polígonos
source("R/fun/dissolve_polygons.R")


# 1. Funcao para download de shape file dos municipios e setores censitarios ------------------
download_muni_setores <- function(ano, munis = "all") {
  

  download_muni_setores_un <- function(sigla_muni) {
    
    
    # extract code muni
    code_munis <- munis_list$munis_metro[abrev_muni == sigla_muni & ano_metro == ano]$code_muni %>% 
      unlist()
    
    # extract state code
    state_code <- substr(code_munis[1], 1, 2) %>% as.numeric()
    
    
    # criar pasta do municipios
    dir.create(sprintf("./R/data-raw/municipios/%s", ano), recursive = TRUE)  
    dir.create(sprintf("./R/data-raw/setores_censitarios/%s", ano), recursive = TRUE)
    # cria hierarquia completa, sem avisar se já existir
    dir.create(sprintf("./R/data/municipios/%s", ano), recursive = TRUE)
    dir.create(sprintf("./R/data/setores_censitarios/%s", ano), recursive = TRUE)
    
    
    # Download de arquivos - shapes dos municipios
    uf_sf <- geobr::read_municipality(state_code)
    muni_sf <- uf_sf %>% filter(code_muni %in% code_munis)
    # muni_sf <- purrr::map_dfr(code_munis, geobr::read_municipality, year=ano, simplified = F)
    # Dissolver os polígonos dos municípios componentes da RM
    muni_sf <- dissolve_polygons(muni_sf, group_column = "code_state")
    muni_sf <- st_transform(muni_sf, 4326)

    # Download de arquivos - shapes dos setores censitarios
    uf_sf_tracts <- geobr::read_census_tract(state_code, simplified = FALSE)
    ct_sf <- uf_sf_tracts %>% filter(code_muni %in% code_munis)
    ct_sf <- st_transform(ct_sf, 4326)
    # mapview(ct_sf)


    # salvar municipios
    readr::write_rds(muni_sf, sprintf("./R/data/municipios/%s/municipio_%s_%s.rds", ano, sigla_muni, ano), compress = 'gz')
    
    # salvar setores censitarios
    readr::write_rds(ct_sf, sprintf("./R/data/setores_censitarios/%s/setores_%s_%s.rds", ano, sigla_muni, ano), compress = 'gz')
  }
  
  # 2. Aplica funcao ------------------------------------------
  if (munis == "all") {
    
    # seleciona todos municipios ou RMs do ano escolhido
    x = munis_list$munis_metro[ano_metro == ano]$abrev_muni
    
  } else (x = munis)
  
  
  lapply(X=x, FUN=download_muni_setores_un)
  
  
}


download_muni_setores(ano = 2017)
download_muni_setores(ano = 2018)
download_muni_setores(ano = 2019)
download_muni_setores(ano = 2020)

