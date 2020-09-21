# Módulo Tweets

Este módulo é responsável por baixar e processar os dados dos tweets do Leggo twitter.

Para exportar esses dados, é necessário estar neste diretório e executar o script abaixo:

```
  Rscript export_tweets.R -o <output_filepath>
```

O argumento **<output_filepath>** é o caminho destino do csv. O valor default é `data/tweets/tweets.csv`.