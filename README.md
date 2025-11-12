# Orbit Analytics

Plataforma simplificada para ingestão de arquivos CSV financeiros, consolidação em data warehouse relacional e visualização de indicadores em dashboard React.

## Estrutura do projeto

```
backend/              # API FastAPI + serviços de ingestão
frontend/             # Dashboard React (Vite)
database/schema/      # Definição das dimensões e fatos em SQL
```

## Executando o backend

1. Copie o arquivo de exemplo e configure as variáveis do Supabase:

   ```bash
   cd backend
   cp .env.example .env
   # edite .env com ORBIT_SUPABASE_PROJECT_REF, ORBIT_SUPABASE_DB_PASSWORD etc.
   ```

   Caso já possua a URL de conexão completa fornecida pelo Supabase, defina `ORBIT_DATABASE_URL` diretamente.

2. Crie o ambiente virtual e instale as dependências:

   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

3. Execute a API:

   ```bash
   uvicorn backend.main:app --reload
   ```

A API expõe:

- `POST /api/import/{dataset}` – upload de CSVs dos datasets `dre` e `indicator`.
- `GET /api/dre/resumo` – agregações de DRE com filtros opcionais.
- `GET /api/indicadores` – valores consolidados de indicadores operacionais.

Os arquivos importados registram histórico em `import_history` para auditoria.

## Executando o frontend

```bash
cd frontend
npm install
npm run dev
```

O servidor de desenvolvimento do Vite faz proxy automático para `http://localhost:8000/api`.

## Modelagem dos dados

Consulte `database/schema/README.md` para o dicionário de dados dos CSVs e DDL das tabelas de fatos e dimensões.
