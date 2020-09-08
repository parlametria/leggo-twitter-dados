#' @title Baixa os parlamentares em execício
#' @description Retorna os parlamentares que estão em exercício
#' @return Dataframe com informações dos parlamentares em exercício,
#' como id, casa, nome, partido e uf.
fetch_parlamentares_em_exercicio <- function() {
  library(tidyverse)
  
  url <-
    "https://dev.api.leggo.org.br/entidades/parlamentares/exercicio"
  
  parlamentares <- RCurl::getURL(url, .encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  
  parlamentares <- parlamentares %>%
    rename(id_parlamentar = id_autor_parlametria,
           casa = casa_autor,
           nome = nome_autor)
  
  return(parlamentares)
  
}
