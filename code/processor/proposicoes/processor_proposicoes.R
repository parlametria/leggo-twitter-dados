library(tidyverse)

#' @title Processa os dados das proposições no formato do banco.
#' @description Retorna os dados das proposições processados.
#' @param proposicoes_datapath Caminho para o csv de proposições
#' @return Dataframe com informações processadas das proposições.
process_proposicoes <-
  function(proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv")) {
    
    proposicoes <- read_csv(proposicoes_datapath, col_types = cols(.default = "c"))
    
    col_names <- c("id_proposicao_leggo", "casa", "casa_origem", "sigla")
    
    if ("destaque" %in% names(proposicoes)) {
      col_names <- c("id_proposicao_leggo", "casa", "casa_origem", "sigla", "destaque")
    }
    
    proposicoes <- proposicoes %>% 
      rename(id_proposicao_leggo = id_proposicao) %>% 
      select(all_of(col_names))
    
    proposicoes <- proposicoes %>%
      mutate(casa_origem = if_else(casa_origem == 'nan', as.character(NA), casa_origem)) %>%
      distinct(id_proposicao_leggo, .keep_all = TRUE)
    
    return(proposicoes)
  }