# Estrutura de Dados Financeiros

Este diretório descreve o mapeamento entre os arquivos CSV de entrada e as tabelas do data warehouse relacional utilizado pelo backend.

## Estrutura dos CSVs

### Demonstrativo de Resultados (dataset `dre`)

| Coluna             | Tipo        | Descrição                                        |
| ------------------ | ----------- | ------------------------------------------------ |
| `date`             | `date`      | Data de competência (YYYY-MM-DD ou DD/MM/YYYY).  |
| `account_code`     | `string`    | Código único da conta contábil.                  |
| `account_name`     | `string`    | Nome da conta contábil.                          |
| `account_type`     | `string`    | Classificação (Receita, Despesa, etc.).          |
| `company_code`     | `string`    | Código da empresa responsável pelo registro.     |
| `company_name`     | `string`    | Nome da empresa.                                 |
| `cost_center_code` | `string`    | Código do centro de custo (opcional).            |
| `cost_center_name` | `string`    | Nome do centro de custo (opcional).              |
| `amount`           | `numeric`   | Valor monetário do lançamento (positivo/negativo).|

### Indicadores Operacionais (dataset `indicator`)

| Coluna             | Tipo      | Descrição                                                      |
| ------------------ | --------- | -------------------------------------------------------------- |
| `period`           | `date`    | Data/período de referência.                                    |
| `indicator_code`   | `string`  | Código único do indicador.                                     |
| `indicator_name`   | `string`  | Nome do indicador.                                             |
| `indicator_unit`   | `string`  | Unidade de medida (%, R$, etc.).                               |
| `company_code`     | `string`  | Código da empresa (opcional para indicadores corporativos).    |
| `company_name`     | `string`  | Nome da empresa correspondente ao código informado.            |
| `value`            | `numeric` | Valor apurado para o indicador.                                |

## Esquema Relacional

Os arquivos SQL a seguir descrevem as dimensões e fatos que suportam o dashboard analítico.

- `01_dimensions.sql`: Criação das tabelas dimensionais (datas, empresas, centros de custo, contas contábeis, indicadores).
- `02_facts.sql`: Criação das tabelas fato (`fact_dre_entry` e `fact_indicator_value`) e da tabela de histórico de importações (`import_history`).

A modelagem utiliza chaves surrogates inteiras em todas as dimensões e garante unicidade através de restrições `UNIQUE` para códigos naturais, permitindo upsert consistente durante a ingestão.
