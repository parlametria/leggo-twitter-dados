.export_proposicoes <-
  function(output_folderpath = here::here("data/bd/")) {
    source(here::here("code/processor/proposicoes/processor_proposicoes.R"))
    
    message("Iniciando processamento e exportação dos dados de proposições...")
    message("Processando dados...")
    
    proposicoes <- process_proposicoes()
    
    message("Salvando dados...")
    write_csv(proposicoes,
              paste0(output_folderpath, "proposicoes/proposicoes.csv"))
    
    message("Feito!")
  }
