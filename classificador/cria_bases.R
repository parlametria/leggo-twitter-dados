library(tidyverse)
library(here)
library(optparse)

option_list = list(
  make_option(
    opt_str = c("-m", "--mencoes"),
    type = "character",
    default = here("src/data/experimento_classificador/muitas_proposicoes/novos_dados/novas_mencoes.csv"),
    help = "Caminho do arquivo de menções [default= %default]",
    metavar = "character"
  ),
  make_option(
    opt_str = c("-t", "--tweets"),
    type = "character",
    default = here("src/data/experimento_classificador/muitas_proposicoes/15-12/tweets_todos.csv"),
    help = "Caminho do arquivo de tweets [default= %default]",
    metavar = "character"
  ),
  make_option(
    opt_str = c("-o", "--output"),
    type = "character",
    default = here("src/data/experimento_classificador/muitas_proposicoes/novos_dados/bases/"),
    help = "Caminho do diretório onde serão salvos os csvs [default= %default]",
    metavar = "character"
  )
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

path_mencoes = opt$mencoes
path_tweets = opt$tweets
out_dir = opt$output

message(paste0("Diretório de trabalho: ", here()))


cria_treino_teste <- function(path_mencoes, path_tweets) {
  message(paste0("Lendo menções de ", path_mencoes))
  mencoes <- read_csv(path_mencoes,
                      col_types = cols(id_tweet = col_character())) 
  
  message(paste0("Lendo tweets de ", path_tweets))
  tweets <- read_csv(path_tweets,
                     col_types = cols(id_tweet = col_character())) %>% 
    anti_join(mencoes,
              by = "id_tweet")
  
  
  pls_citadas <- mencoes %>% 
    count(citadas, sort = T) %>% 
    filter(n >= 20) %>% 
    pull(citadas)
  
  seleciona_tweets <- function(proposicao) {
    message(paste0("Selecionando tweets para ", proposicao))
    
    selecionadas <- mencoes %>% 
      filter(citadas == proposicao,
             str_length(removido) > 10) %>% 
      group_by(id_tweet) %>% 
      slice_sample(n = 1) %>% 
      ungroup() %>% 
      slice_sample(n = if_else((NROW(.) - 4) >= 100, 
                               100, 
                               NROW(.) - 4)) %>% 
      mutate(proposicao = proposicao,
             base = "treino",
             classe = "positivo")
    
    selecionadas_teste <- mencoes %>% 
      anti_join(selecionadas,
                by = "id_tweet") %>% 
      filter(citadas == proposicao,
             str_length(removido) > 100) %>% 
      slice_sample(n = 4) %>% 
      mutate(proposicao = proposicao,
             base = "teste",
             classe = "positivo")
    
    nulas <- tweets %>% 
      filter(!is.na(text),
             !grepl("^http", text),
             !grepl("\\@\\S+", text),
             str_length(text) > 100) %>%
      slice_sample(n = selecionadas %>% NROW(.)) %>% 
      mutate(removido = text,
             proposicao = proposicao,
             base = "treino",
             classe = "negativo")
    
    nulas_teste <- tweets %>% 
      anti_join(nulas,
                by = "id_tweet") %>% 
      filter(!is.na(text),
             !grepl("^http", text),
             !grepl("\\@\\S+", text),
             str_length(text) > 100) %>% 
      slice_sample(n = 196) %>% 
      mutate(removido = text,
             proposicao = proposicao,
             base = "teste",
             classe = "negativo")
    
    base <- bind_rows(selecionadas, nulas, selecionadas_teste, nulas_teste) %>% 
      select(id_tweet, removido, citadas, proposicao, base, classe) %>% 
      mutate(rotulo = if_else(classe == "positivo", 1, 0))
    
    treino <- base %>% filter(base == "treino")
    teste <- base %>% filter(base == "teste")
    pl <- str_replace(string = proposicao, pattern = " ", replacement = "_")
    message(paste0("Salvando csvs em ", out_dir))
    write_csv(treino, paste0(out_dir, pl, '_treino.csv'))
    write_csv(teste, paste0(out_dir, pl, '_teste.csv'))
  }
  
  pls_citadas %>% map(., seleciona_tweets)
}

cria_treino_teste(path_mencoes, path_tweets)

# pls <- pls %>% 
#   select(id_tweet, removido, citadas, proposicao, base, classe) %>% 
#   mutate(rotulo = if_else(classe == "positivo", 1, 0))
# 
# pls_selecionadas <- pls %>% distinct(citadas) %>% pull(citadas) %>% na.omit()
# 
# for (pl in pls_selecionadas) {
#   pls %>% 
#     filter(pl == proposicao,
#            base == 'treino') -> treino
#   
#   pls %>% 
#     filter(pl == proposicao,
#            base == 'teste') -> teste
#   
#   path <- here("src/data/experimento_classificador/muitas_proposicoes/novos_dados/bases/")
#   pl <- str_replace(string = pl, pattern = " ", replacement = "_")
#   write_csv(treino, paste0(path, pl, '_treino.csv'))
#   write_csv(teste, paste0(path, pl, '_teste.csv'))
# }
# 
