# Pacote de replicação - Introdução à Econometria, Listas 1 a 5

Este pacote acompanha o notebook `Introducao_a_econometria_resolvido.ipynb` e organiza scripts em **Python**, **R** e **Stata** para replicar as soluções numéricas, econométricas e gráficas das listas.

## Estrutura

```text
econometria_wooldridge_replication/
├── python/              # scripts Python
├── R/                   # scripts R
├── stata/               # scripts Stata
├── data/manual/         # dados digitados dos enunciados e ganchos para bases da disciplina
├── outputs/tables/      # saídas tabulares
├── outputs/figures/     # gráficos em PNG e PDF, separados por linguagem
└── logs/                # logs
```

## Notebook

O notebook foi ajustado para usar:

- `### Lista ...` para separar cada lista;
- `## Questão ...` para separar as questões;
- equações em blocos `\begin{equation} ... \end{equation}`;
- células de código com gráficos ilustrativos quando a questão permite visualização.

## Bases do Wooldridge

Quando a questão usa bases clássicas do Wooldridge, os scripts buscam os dados pelas bibliotecas correspondentes:

- Python: pacote `wooldridge`, função `wooldridge.data("nome_da_base")`.
- R: pacote `wooldridge`, com `data("nome_da_base", package = "wooldridge")`.
- Stata: comando `bcuse nome_da_base, clear`, após instalar `bcuse` via `ssc install bcuse`.

## Bases específicas da disciplina

Algumas questões citam arquivos específicos da disciplina, não anexados aos PDFs e não pertencentes às bibliotecas usuais do Wooldridge. Nesses casos, os scripts deixam ganchos:

- `data/manual/cars_lista02.csv` para a questão dos 81 modelos de carros da Lista 2.
- `data/manual/municipios_lista05.csv` para a questão municipal da Lista 5.

Se esses arquivos forem colocados nessa pasta com os nomes e colunas indicados nos scripts, a replicação roda automaticamente e gera também os gráficos correspondentes.

## Como executar

### Python

```bash
cd econometria_wooldridge_replication
python -m pip install -r requirements.txt
python python/run_all.py
```

### R

```r
setwd("econometria_wooldridge_replication")
source("R/run_all.R")
```

### Stata

```stata
cd "econometria_wooldridge_replication"
do stata/run_all.do
```
