# Módulo Usuários

Este módulo é responsável por baixar os dados dos usuários do Twitter monitorados pelo Leggo Twitter. 

Para exportar esses dados, é necessário configurar a variável de ambiente **URL_USERNAMES_TWITTER** no arquivo `.env` localizado na raiz deste repositório, estar neste diretório e executar o script abaixo:

```
  Rscript export_usuarios.R -o <output_filepath>
```

O argumento **<output_filepath>** é o caminho destino do csv. O valor default é `data/usuarios/usuarios.csv`