#' @title Baixa os parlamentares em execício
#' @description Retorna os parlamentares que estão em exercício
#' @param api_url URL da api do Parlametria. (Não incluir a '/' ao final do domínio).
#' @return Dataframe com informações dos parlamentares em exercício,
#' como id, casa, nome, partido e uf.
fetch_parlamentares_em_exercicio <- function(api_url = "https://api.parlametria.org.br") {
  library(tidyverse)
  
  url <-
    paste0(api_url, 
           "/entidades/parlamentares/exercicio")
  
  parlamentares <- RCurl::getURL(url, .encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  
  parlamentares <- parlamentares %>%
    rename(id_parlamentar_parlametria = id_autor_parlametria,
           casa = casa_autor,
           nome = nome_autor)
  
  return(parlamentares)
  
}
