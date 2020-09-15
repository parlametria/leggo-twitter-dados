library(tidyverse)

#' @title Remove a ambiguidade das proposições com mesma sigla e numero
#' @description Remove a ambiguidade das proposições com mesma sigla e numero,
#' priorizando a que possui ano de apresentação mais recente
#' @param proposicoes Dataframe de proposições
#' @return Dataframe com proposições distintas
.remove_ambiguidade_siglas <- function(proposicoes) {

  proposicoes_sem_ambiguidade <- proposicoes %>% 
    select(id_proposicao_leggo = id_proposicao, sigla) %>% 
    mutate(
      sigla_sem_ano = str_remove(sigla, "\\/\\d.*"),
      ano = str_extract(sigla, "\\/\\d.*") %>% str_remove("\\/"),
      ## TODO: remover linha abaixo quando o ano da PL 669/2019 estiver resolvido
      ano = if_else(id_proposicao_leggo == "9104fcae3c644d1e87007b78bebd26b9",
                    "2019",
                    ano)
    ) %>%
    group_by(sigla_sem_ano) %>%
    mutate(max_ano = max(ano)) %>%
    ungroup() %>% 
    mutate(
      id_proposicao_leggo = if_else(
        ano == max_ano, 
        id_proposicao_leggo, 
        as.character(NA))) %>%
    filter(!is.na(id_proposicao_leggo)) %>%
    select(id_proposicao_leggo, sigla = sigla_sem_ano) %>% 
    distinct()
  
  return(proposicoes_sem_ambiguidade)
}
#' @title Processa os dados dos tweets no formato do banco.
#' @description Retorna os dados dos tweets processados.
#' @param tweets_datapath Caminho para o csv de tweets
#' @param parlamentares_datapath Caminho para o csv de parlamentares
#' @return Dataframe com informações processadas dos tweets
process_tweets <-
  function(tweets_datapath = here::here("data/tweets/tweets.csv"),
           parlamentares_datapath = here::here("data/bd/parlamentares/parlamentares.csv")) {
    source(here::here("code/processor/parlamentares/processor_parlamentares.R"))
    
    tweets <-
      read_csv(tweets_datapath, col_types = "cccccidddddddccc") %>%
      .generate_id_parlamentar_parlametria() %>%
      select(-c(id_parlamentar, casa, citadas)) %>%
      distinct()
    
    parlamentares <-
      read_csv(parlamentares_datapath, col_types = cols(.default = "c"))
    
    tweets <- tweets %>%
      inner_join(parlamentares, by = "id_parlamentar_parlametria") %>%
      select(
        id_tweet,
        id_parlamentar_parlametria,
        username,
        created_at,
        text,
        interactions,
        url = status_url,
        outrage,
        vagueness,
        argumentation,
        modalization,
        valuation,
        sentiment,
        presupposition
      )
    
    return(tweets)
  }

#' @title Processa os dados do mapeamento de tweets e proposições no formato do banco.
#' @description Retorna os dados do mapeamento de tweets e proposiçõeprocessados.
#' @param tweets_datapath Caminho para o csv de tweets
#' @param proposicoes_datapath Caminho para o csv de proposições (sem o processamento para o BD)
#' @return Dataframe com informações processadas do mapeamento de tweets e proposições
process_tweets_proposicoes <-
  function(tweets_datapath = here::here("data/tweets/tweets.csv"),
           tweets_processados_datapath = here::here("data/bd/tweets/tweets.csv"),
           proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv")) {
    
    tweets_com_parlamentares_em_exercicio <-
      read_csv(tweets_processados_datapath, col_types = "cccccicddddddd") %>%
      select(id_tweet) %>%
      distinct()
    
    tweets <-
      read_csv(tweets_datapath, col_types = "cccccidddddddccc") %>%
      select(id_tweet, sigla = citadas) %>%
      distinct() %>%
      inner_join(tweets_com_parlamentares_em_exercicio, by = "id_tweet")
    
    proposicoes <-
      read_csv(proposicoes_datapath, col_types = cols(.default = "c")) %>%
      .remove_ambiguidade_siglas() %>% 
      mutate(sigla = str_replace(sigla, "MPV", "MP"))
    
    tweets_proposicoes <- tweets %>%
      left_join(proposicoes, by = c("sigla")) %>%
      filter(!is.na(id_tweet),!is.na(id_proposicao_leggo)) %>%
      distinct()
    
    return(tweets_proposicoes)
  }
