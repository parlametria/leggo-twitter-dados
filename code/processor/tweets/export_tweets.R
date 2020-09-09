.export_tweets <-
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/tweets/processor_tweets.R"))
    
    message("Iniciando processamento e exportação dos dados de tweets...")
    message("Processando dados...")
    
    tweets <- process_tweets()
    
    message("Salvando dados...")
    write_csv(tweets,
              paste0(output_folderpath, "tweets/tweets.csv"))
    
    message("Feito!")
  }

.export_tweets_proposicoes <- 
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/tweets/processor_tweets.R"))
    
    message("Iniciando processamento e exportação dos dados de tweets e proposições...")
    message("Processando dados...")
    
    tweets <- process_tweets_proposicoes()
    
    message("Salvando dados...")
    write_csv(tweets,
              paste0(output_folderpath, "tweets/tweets_proposicoes.csv"))
    
    message("Feito!")
  }