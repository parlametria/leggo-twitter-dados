library(tidyverse)

processa_usuarios_com_interacao <-
  function(folderpath = "reports/interacoes_katia_abreu/data/") {
    interacoes_katia_abreu <-
      read_csv(paste0(folderpath, "tweets_to_process.csv"),
               col_types = cols(id_tweet = "c")) %>%
      mutate(mention = strsplit(mentions, ";")) %>%
      unnest(mention) %>%
      filter(!is.na(mention), mention != "") %>%
      mutate(mention = paste0("@", tolower(mention))) %>%
      mutate(date = format(as.Date(date), "%d/%m/%Y")) %>% 
      mutate(mentions = gsub("^", "@", mentions)) %>% 
      mutate(mentions = gsub(";", "; @", mentions))
    
    
    interacoes_outros_usuarios <-
      read_csv(paste0(folderpath, "tweets_to_process_all.csv"),
               col_types = cols(id_tweet = "c")) %>%
      mutate(mentions_extract = stringr::str_extract_all(tolower(text), "@[A-Za-z0-9_]+")) %>%
      mutate(mentions = sapply(mentions_extract, paste, collapse = "; ")) %>%
      filter(mentions != "") %>%
      select(-mentions_extract) %>%
      mutate(mention = strsplit(mentions, "; ")) %>%
      unnest(mention) %>%
      mutate(date =  format(as.Date(date), "%d/%m/%Y"))
    
    interacoes_katia_alt <-
      bind_rows(
        interacoes_katia_abreu,
        interacoes_outros_usuarios
      ) %>% 
      distinct(id_tweet, mention, .keep_all = T)
    return(interacoes_katia_alt)
  }
