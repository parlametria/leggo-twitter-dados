#' @title Baixa as proposições por agenda
#' @description Recebe uma agenda e retorna as proposições monitoradas pelo
#' Leggo com essa agenda.
#' @param agenda Agenda de interesse (obs: sem acentos e espaços,
#' ex: reforma-tributaria)
#' @param api_url URL da api do Parlametria. (Não incluir a '/' ao final do domínio).
#' @return Dataframe com informações das proposições de uma agenda.
fetch_proposicoes_by_agenda <-
  function(agenda = "transparencia-e-integridade",
           api_url = "https://dev.api.leggo.org.br") {
    library(tidyverse)

    print(paste0("Baixando proposições da agenda ", agenda, "..."))
    
    url <-
      paste0(api_url, 
             "/proposicoes/?interesse=",
             agenda)
    
    df <-
      RCurl::getURL(url, .encoding = "UTF-8") %>%
      jsonlite::fromJSON()
    
    proposicoes <- tibble(
      id_proposicao = df$id_leggo,
      interesse = df$interesse,
      etapas = df$etapas
    ) %>%
      unnest(cols = c(interesse, etapas)) %>% 
      mutate(temas = purrr::map(temas, ~ as.list(.))) %>%
      mutate(slug_temas = purrr::map(slug_temas, ~ as.list(.))) %>%
      unnest(cols = c(temas, slug_temas)) %>% 
      unnest(cols = c(temas, slug_temas))
    
    destaques <- df$destaques %>%
      bind_rows()
    
    if (nrow(destaques) > 0) {
      destaques <- destaques %>%
        mutate(
          destaque = (
            criterio_req_urgencia_apresentado ||
              criterio_req_urgencia_aprovado ||
              criterio_aprovada_em_uma_casa
          )
        ) %>%
        select(id_leggo, destaque)
      
      proposicoes <- proposicoes %>%
        left_join(destaques, by = c("id_proposicao" = "id_leggo")) %>%
        mutate(destaque = if_else(is.na(destaque), F, destaque))
      
    } else {
      proposicoes <- proposicoes %>%
        mutate(destaque = FALSE)
    }
    
    proposicoes_casa_origem <- proposicoes %>% 
      group_by(id_proposicao) %>% 
      mutate(last_apresentacao = min(data_apresentacao)) %>% 
      ungroup() %>% 
      filter(last_apresentacao == data_apresentacao) %>% 
      select(id_proposicao, casa_origem = casa)
    
    proposicoes <- proposicoes %>% 
      left_join(proposicoes_casa_origem, by = c("id_proposicao")) %>% 
      select(
        id_proposicao,
        interesse_slug = interesse,
        interesse_nome = interesse,
        temas_nome = temas,
        temas_slug = slug_temas,
        sigla,
        casa,
        casa_origem,
        destaque
      ) 
    
    return(proposicoes)
  }

#' @title Baixa as proposições para todas as agendas do Leggo Proposições
#' @description Retorna as proposições monitoradas pelas agendas do Leggo
#' @param api_url URL da api do Parlametria. (Não incluir a '/' ao final do domínio).
#' @return Dataframe com informações das proposições.
fetch_proposicoes_todas_agendas <- function(api_url = "https://dev.api.leggo.org.br") {
  library(tidyverse)
  
  agendas <- RCurl::getURL(paste0(api_url, "/interesses")) %>% 
    jsonlite::fromJSON() %>% 
    select(interesse)
  
  proposicoes <- purrr::map_df(agendas$interesse, 
                               ~ fetch_proposicoes_by_agenda(.x, api_url))
  return(proposicoes)
}
