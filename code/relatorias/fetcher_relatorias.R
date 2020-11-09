#' @title Recupera as relatorias das proposições de uma agenda
#' @description Recupera todos os relatores das proposições de uma agenda
#' @param agenda Agenda de interesse (obs: sem acentos e espaços,
#' ex: reforma-tributaria)
#' @return Dataframe com informações dos relatores das proposições de uma agenda.
fetch_relatores_proposicoes_by_agenda <-
  function(agenda = "congresso-remoto") {
    library(tidyverse)
    
    print(paste0("Baixando relatores de proposições da agenda ", agenda, "..."))
    
    url <-
      paste0("https://api.leggo.org.br/relatores/?interesse=",
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
#' @return Dataframe com informações dos relatores das proposições de todas as agendas.
fetch_relatores_proposicoes_todas_agendas <- function() {
  library(tidyverse)
  
  agendas <- RCurl::getURL("http://dev.api.leggo.org.br/interesses") %>% 
    jsonlite::fromJSON() %>% 
    select(interesse)
  
  relatores <- purrr::map_df(agendas$interesse, 
                               ~ fetch_relatores_proposicoes_by_agenda(.x)) %>% 
    distinct()
  return(relatores)
}
