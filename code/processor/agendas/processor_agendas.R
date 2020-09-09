library(tidyverse)

#' @title Processa os dados das agendas no formato do banco.
#' @description Retorna os dados das agendas processados.
#' @param proposicoes_datapath Caminho para o csv de proposições
#' @return Dataframe com informações processadas das agendas.
process_agendas <-
  function(proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv")) {
    agendas <-
      read_csv(proposicoes_datapath, col_types = cols(.default = "c"))
    
    agendas <- agendas %>%
      select(nome = interesse_nome, slug = interesse_slug) %>%
      distinct() %>%
      rowid_to_column("id")
    
    return(agendas)
  }

#' @title Processa os dados do mapeamento de agendas e proposições no formato do banco.
#' @description Retorna os dados do mapeamento de agendas e proposições.
#' @param proposicoes_datapath Caminho para o csv de proposições
#' @param agendas_datapath Caminho para o csv de agendas
#' @return Dataframe com informações processadas do mapemento das agendas e proposições.
process_agendas_proposicoes <-
  function(proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv"),
           agendas_datapath = here::here("data/bd/agendas/agendas.csv")) {
    
    proposicoes <-
      read_csv(proposicoes_datapath, col_types = cols(.default = "c")) %>%
      select(id_proposicao_leggo = id_proposicao,
             nome = interesse_nome,
             slug = interesse_slug) %>%
      distinct()
    
    agendas <-
      read_csv(agendas_datapath, col_types = cols(.default = "c"))
    
    agendas_proposicoes <-
      proposicoes %>%
      inner_join(agendas, by = c("nome", "slug")) %>%
      select(id_proposicao_leggo, id_agenda = id) %>%
      distinct()
    
    return(agendas_proposicoes)
  }