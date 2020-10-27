#' @title Baixa os tweets da versão inicial
#' @description Retorna os dados de tweets da versão inicial do leggo 
#' twitter
#' @return Dataframe com informações de tweets da versão inicial do leggo 
#' twitter
fetch_mencoes_congresso_remoto <- function() {
  library(tidyverse)
  source(here::here("code/tweets/constants_tweets.R"))
  
  tweets <- read_csv(.URL_MENCOES_CR, col_types = cols(.default = "c")) 
  
  names(tweets) <- names(tweets) %>% 
    tolower()
  
  tweets <- tweets %>% 
    select(-c(nome_eleitoral, partido, uf)) %>% 
    mutate(casa = iconv(casa, to="ASCII//TRANSLIT"))
  
  return(tweets)
}
