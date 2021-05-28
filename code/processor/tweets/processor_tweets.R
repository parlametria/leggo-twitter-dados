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

#' @title Remove o ponto da sigla das proposições citadas nos tweets
#' @description Remove o ponto da sigla das proposições citadas nos tweets
#' @param tweets Dataframe de tweets com citacoes a proposições
#' @return Dataframe identico porém com a sigla modificada
.remove_ponto_sigla <- function(tweets) {
  
  tweets_sem_ponto <- tweets %>% 
    mutate(sigla = str_remove(sigla, "\\."))

  return(tweets_sem_ponto)
}

#' @title Processa os dados dos tweets no formato do banco.
#' @description Retorna os dados dos tweets processados.
#' @param tweets_datapath Caminho para o csv de tweets
#' @param usuarios_datapath Caminho para o csv de usuários monitorados
#' @param parlamentares_datapath Caminho para o csv de parlamentares
#' já processados
#' @return Dataframe com informações processadas dos tweets
process_tweets <-
  function(tweets_datapath = here::here("data/tweets/tweets.csv"),
           usuarios_datapath = here::here("data/usuarios/usuarios.csv"),
           parlamentares_datapath = here::here("data/bd/parlamentares/parlamentares.csv")) {
    source(here::here("code/processor/parlamentares/processor_parlamentares.R"))
    
    parlamentares <- read_csv(parlamentares_datapath,
                              col_types = cols(.default = "c")) %>% 
      select(id_parlamentar_parlametria) %>% 
      mutate(em_exercicio = TRUE)
    
    usuarios <- read_csv(usuarios_datapath) %>%
      .generate_id_parlamentar_parlametria() %>% 
      left_join(parlamentares, by = "id_parlamentar_parlametria") %>% 
      mutate(id_parlamentar_parlametria = if_else(em_exercicio == TRUE,
                                                  id_parlamentar_parlametria,
                                                  NA_character_)) %>% 
      select(username, id_parlamentar_parlametria)
    
    tweets <-
      read_csv(tweets_datapath, col_types = cols(
        reply_count = "i",
        retweet_count = "i",
        like_count = "i",
        quote_count = "i",
        .default = "c"
      ))
    
    tweets <- tweets %>%
      left_join(usuarios, by = c("username"))
    
    tweets <- tweets %>%
      group_by(id_tweet) %>% 
      mutate(interactions = sum(reply_count,
                                retweet_count,
                                like_count,
                                quote_count,
                                na.rm = T)) %>%
      select(
        id_tweet,
        id_parlamentar_parlametria,
        username,
        created_at = date,
        text,
        interactions,
        url
      ) %>%
      mutate(interactions = max(interactions),
             created_at = last(created_at)) %>%
      distinct(id_tweet, .keep_all = TRUE)
    
    return(tweets)
  }

#' @title Processa os dados do mapeamento de tweets e proposições no formato do banco.
#' @description Retorna os dados do mapeamento de tweets e proposiçõeprocessados.
#' @param tweets_datapath Caminho para o csv de tweets
#' @param tweets_processados_datapath Caminho para o csv de tweets processados
#' @param proposicoes_datapath Caminho para o csv de proposições (sem o processamento para o BD)
#' @param relatorias_datapath Caminho para o csv de relatorias
#' @return Dataframe com informações processadas do mapeamento de tweets e proposições
process_tweets_proposicoes <-
  function(tweets_datapath = here::here("data/tweets/tweets.csv"),
           tweets_processados_datapath = here::here("data/bd/tweets/tweets.csv"),
           proposicoes_datapath = here::here("data/proposicoes/proposicoes.csv"),
           relatorias_datapath = here::here("data/relatorias/relatorias.csv")) {
    
    tweets_parlamentares <-
      read_csv(tweets_processados_datapath, col_types = cols(.default = "c")) %>% 
      distinct(id_tweet, id_parlamentar_parlametria)

    tweets <-
      read_csv(tweets_datapath, col_types = cols(.default = "c")) %>%
      select(id_tweet, id_proposicao_leggo = id_proposicao) %>%
      distinct() %>%
      inner_join(tweets_parlamentares, by = "id_tweet")
    
    proposicoes <-
      read_csv(proposicoes_datapath, col_types = cols(.default = "c")) %>%
      .remove_ambiguidade_siglas() %>% 
      mutate(sigla = str_replace(sigla, "MPV", "MP"))
    
    relatorias <- read_csv(relatorias_datapath, col_types = cols(.default = "c")) %>% 
      distinct()
    
    tweets_proposicoes <- tweets %>%
      inner_join(proposicoes, by = c("id_proposicao_leggo")) %>%
      filter(!is.na(id_tweet),!is.na(id_proposicao_leggo)) %>%
      distinct() %>% 
      left_join(relatorias, by = c("id_parlamentar_parlametria",
                                   "id_proposicao_leggo" = "id_proposicao")) %>% 
      mutate(relator_proposicao = !is.na(casa)) %>% 
      select(id_tweet, sigla, id_proposicao_leggo, relator_proposicao) %>% 
      distinct(id_tweet, id_proposicao_leggo, .keep_all = T)

    return(tweets_proposicoes)
  }

#' @title Processa os dados do sumário de tweets processados e usuários monitorados.
#' @description Retorna os dados de total de tweets processados,
#' total de parlamentares e influenciadores monitorados.
#' @param tweets_processados_datapath Caminho para o csv de tweets processados
#' @param usuarios_datapath Caminho para o csv de usuários
#' @return Dataframe com dados do sumário de tweets processados e usuários monitorados
process_tweets_raw_info <- function(tweets_processados_datapath = here::here("data/tweets/tweets_processados.csv"),
                                    usuarios_datapath = here::here("data/usuarios/usuarios.csv"),
                                    parlamentares_datapath = here::here("data/parlamentares/parlamentares.csv")) {
  source(here::here("code/processor/parlamentares/processor_parlamentares.R"))
  
  total_tweets_processados <-
    length(count.fields(tweets_processados_datapath, sep = ",")) - 1
  
  parlamentares <-
    read_csv(parlamentares_datapath, col_types = cols(.default = "c")) %>%
    distinct(id_parlamentar_parlametria) %>% 
    mutate(em_exercicio = T)
  
  usuarios <- read_csv(usuarios_datapath) %>%
    .generate_id_parlamentar_parlametria() %>% 
    left_join(parlamentares, by = "id_parlamentar_parlametria") 
  
  # Calcula nº de parlamentares em exercício que possuem pelo
  # menos uma conta no Twittter
  usuarios_parlamentares_em_exercicio <- usuarios %>% 
    filter(!is.na(id_parlamentar_parlametria), em_exercicio) %>% 
    distinct(id_parlamentar_parlametria) %>% 
    nrow()
  
  total_influencers <- usuarios %>%
    filter(is.na(id_parlamentar_parlametria) | is.na(em_exercicio)) %>% 
    nrow()
  
  tweet_raw_info_df <-
    tibble(id = 1,
           total_tweets = total_tweets_processados,
           total_parlamentares = usuarios_parlamentares_em_exercicio,
           total_influencers = total_influencers) 
  
  return(tweet_raw_info_df)
}
