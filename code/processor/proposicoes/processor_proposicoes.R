library(tidyverse)

#' @title Processa os dados das proposições no formato do banco.
#' @description Retorna os dados das proposições processados.
#' @param proposicoes_datapath Caminho para o csv de proposições
#' @return Dataframe com informações processadas das proposições.
process_proposicoes <-
  function(proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv")) {
    
    proposicoes <- read_csv(proposicoes_datapath, col_types = cols(.default = "c"))
    
    proposicoes <- proposicoes %>% 
      select(id_proposicao_leggo = id_proposicao, casa, casa_origem, sigla) %>% 
      mutate(casa_origem = if_else(casa_origem == 'nan', as.character(NA), casa_origem)) %>% 
      distinct()
    
    return(proposicoes)
  }