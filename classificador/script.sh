#!/bin/bash

set -euo pipefail
python -m venv environment
source environment/bin/activate
pip install -r requirements.txt
Rscript cria_bases.R
python knn.py
