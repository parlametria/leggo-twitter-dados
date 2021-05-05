# Crawler

Este módulo é responsável por coletar os tweets dos parlamentares diretamente do twitter.

## Requirements
```
pip3 install -r requirements.txt
```
## Como rodar o código? 

Para realizar uma coleta, basta rodar o script abaixo:

```
  python3 crawler_snscrape.py --input_inf INFLUENCERS.csv --since YYYY-MM-DD --until YYYY-MM-DD
```
- `--input_inf` : csv de entrada com os usuários dos Influencers/veículos de mídia. O csv deve, obrigatóriamente, ter as colunas nome, twitter e grupo.
    - Default : `influencers.csv`

- `--since` : data de início da coleta, no formato Ano-Mês-Dia (YYYY-MM-DD).
    - Default : `2019-01-01`
	
- `--until`	 : data de fim da coleta, no formato Ano-Mês-Dia (YYYY-MM-DD).
	- Default : `2020-07-01`