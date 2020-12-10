#' @title Recupera as relatorias das proposições de uma agenda
#' @description Recupera todos os relatores das proposições de uma agenda
#' @param agenda Agenda de interesse (obs: sem acentos e espaços,
#' ex: reforma-tributaria)
#' @param api_url URL da api do Parlametria. (Não incluir a '/' ao final do domínio).
#' @return Dataframe com informações dos relatores das proposições de uma agenda.
fetch_relatores_proposicoes_by_agenda <-
  function(agenda = "congresso-remoto",
           api_url = "https://dev.api.leggo.org.br") {
    library(tidyverse)
    
    print(paste0("Baixando relatores de proposições da agenda ", agenda, "..."))
    
    url <-
      paste0(api_url, 
             "/relatores/?interesse=",
             agenda)
    
    df <-
      RCurl::getURL(url, .encoding = "UTF-8") %>%
      jsonlite::fromJSON()
    
    relatores <- df %>%
      select(id_parlamentar_parlametria = relator_id_parlametria,
             id_proposicao = id_leggo,
             casa) %>% 
      distinct()
    
    return(relatores)
  }

#' @title Recupera as relatorias das proposições de todas as agendas
#' @description Retorna relatorias de proposições de todas as agendas
#' @param api_url URL da api do Parlametria. (Não incluir a '/' ao final do domínio).
#' @return Dataframe com informações dos relatores das proposições de todas as agendas.
fetch_relatores_proposicoes_todas_agendas <- function(api_url = "https://dev.api.leggo.org.br") {
  library(tidyverse)
  
  agendas <- RCurl::getURL(paste0(api_url, "/interesses")) %>% 
    jsonlite::fromJSON() %>% 
    select(interesse)
  
  relatores <- purrr::map_df(agendas$interesse, 
                               ~ fetch_relatores_proposicoes_by_agenda(.x, api_url)) %>% 
    distinct()
  return(relatores)
}
