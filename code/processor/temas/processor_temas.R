library(tidyverse)

#' @title Processa os dados de temas no formato do banco.
#' @description Retorna os dados de temas processados.
#' @param proposicoes_datapath Caminho para o csv de proposições
#' @return Dataframe com informações processada dos usernames dos parlamentares.
process_temas <-
  function(proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv")) {
    temas <-
      read_csv(proposicoes_datapath, col_types = cols(.default = "c"))
    
    temas <- temas %>%
      select(nome = temas_nome, slug = temas_slug) %>%
      mutate(nome = str_to_title(nome)) %>%
      distinct() %>%
      rowid_to_column("id")
    
    return(temas)
  }

#' @title Processa os dados do mapeamento de temas e proposições no formato do banco.
#' @description Retorna os dados do mapeamento de temas e proposições.
#' @param proposicoes_datapath Caminho para o csv de proposições
#' @param temas_datapath Caminho para o csv de temas
#' @return Dataframe com informações processadas do mapemento das temas e proposições.
process_temas_proposicoes <-
  function(proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv"),
           temas_datapath = here::here("data/bd/temas/temas.csv")) {
    
    proposicoes <-
      read_csv(proposicoes_datapath, col_types = cols(.default = "c")) %>%
      select(id_proposicao_leggo = id_proposicao,
             nome = temas_nome,
             slug = temas_slug) %>%
      distinct()
    
    temas <-
      read_csv(temas_datapath, col_types = cols(.default = "c"))
    
    temas_proposicoes <-
      proposicoes %>%
      inner_join(temas, by = c("nome", "slug")) %>%
      select(id_proposicao_leggo, id_tema = id) %>%
      distinct()
    
    return(temas_proposicoes)
    
  }