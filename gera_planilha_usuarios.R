library(tidyverse)

.generate_classificacao <- function(influencers_df) {
  classificacoes <- influencers_df %>%
    gather(tipo_classificacao, flag, deputadosfederais:politico) %>%
    filter(flag == 1) %>%
    group_by(username) %>%
    mutate(classificacao = paste0(tipo_classificacao, collapse = ";")) %>%
    distinct(username, classificacao)
  
  influencers_df <- influencers_df %>% 
    select(username, nome, id_parlamentar, casa) %>% 
    left_join(classificacoes, by = c("username"))
  
  return(influencers_df)
}

.generate_id_parlamentar <- function(influencers_df) {
  influencers_df <- influencers_df %>%
    mutate(casa = if_else(
      id_deputado > 0,
      "câmara",
      if_else(id_senador > 0,
              "senado",
              NA_character_)
    )) %>%
    mutate(id_parlamentar = if_else(
      casa == "câmara",
      as.integer(id_deputado),
      if_else(casa == "senado",
              as.integer(id_senador),
              NA_integer_),
    )) %>%
    select(-c(id_deputado, id_senador))
  
  return(influencers_df)
  
}

process_influencers <-
  function(influencers_filepath = here::here("data/usuarios/influencers.csv")) {
    influencers <- read_csv(influencers_filepath)
    
    influencers_users <- influencers %>%
      distinct(user, name, .keep_all = T) %>%
      select(
        username = user,
        nome = name,
        id_deputado,
        id_senador,
        deputadosfederais:politico
      ) %>%
      .generate_id_parlamentar() %>%
      .generate_classificacao() %>%
      mutate(source = "gps_folha") %>%
      select(username,
             nome,
             id_parlamentar,
             casa,
             source,
             classificacao) %>%
      distinct()
    
    return(influencers_users)
  }

process_parlamentares <-
  function(perfil_parlamentar_filepath = here::here("data/parlamentares/perfil_parlamentar.csv")) {
    parlamentares <-
      read_csv(perfil_parlamentar_filepath)
    
    parlamentares_users <- parlamentares %>%
      distinct(nome_eleitoral, twitter, .keep_all = T) %>%
      mutate(casa_enum = if_else(casa == "câmara", 1, 2)) %>%
      mutate(
        classificacao = if_else(casa == "câmara", "deputadosfederais", "senadores"),
        source = "perfil_parlamentar"
      ) %>%
      distinct(
        username = twitter,
        nome = nome_eleitoral,
        id_parlamentar,
        casa,
        source,
        classificacao
      )
    
    return(parlamentares_users)
  }

process_usuarios <- function(influencers_filepath,
                             perfil_parlamentar_filepath) {
  parlamentares_users <-
    process_parlamentares(perfil_parlamentar_filepath)
  
  influencers_users <- process_influencers(influencers_filepath)
  
  usuarios <- parlamentares_users %>%
    bind_rows(influencers_users) %>%
    mutate(username_processed = username %>%
             str_replace_all("[^[:alnum:]|^[:punct:]]" , "")) %>%
    mutate(username_processed = tolower(username_processed) %>%
             str_replace_all("[\r\n]" , "")) %>%
    mutate(username_processed = trimws(username_processed, which = c("both"))) %>%
    distinct(username_processed, .keep_all = TRUE) %>%
    filter(!is.na(username_processed)) %>%
    select(username = username_processed,
           nome,
           id_parlamentar,
           casa,
           source,
           classificacao)
  
  return(usuarios)
}

usuarios <-
  process_usuarios(
    here::here("data/usuarios/influencers.csv"),
    here::here("data/parlamentares/perfil_parlamentar.csv")
  )

write_csv(usuarios, here::here("data/usuarios/planilha_usuarios.csv"), na="")
