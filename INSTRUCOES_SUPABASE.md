# 🎯 Como Executar o SQL no Supabase

## Passo 1: Abra o SQL Editor do Supabase

1. Acesse: https://supabase.com/dashboard/project/darrtoexfebfbmzyubxf/sql/new
2. Você verá um editor de SQL em branco

## Passo 2: Cole o SQL Completo

1. Abra o arquivo: **`SUPABASE_SQL_COMPLETO.sql`** (está na raiz do projeto)
2. **Copie TODO o conteúdo** do arquivo (Ctrl+A, Ctrl+C ou Cmd+A, Cmd+C no Mac)
3. **Cole no SQL Editor** do Supabase (Ctrl+V ou Cmd+V)

## Passo 3: Execute o SQL

1. Clique no botão **"RUN"** (ou pressione Ctrl+Enter / Cmd+Enter)
2. Aguarde a execução (pode levar alguns segundos)
3. Você verá a mensagem de sucesso quando terminar

## O que este SQL faz?

✅ Cria todas as 15 tabelas do banco de dados
✅ Cria todos os índices para performance
✅ Configura as foreign keys (relacionamentos)
✅ Insere dados de demonstração:
   - 1 empresa demo
   - 3 departamentos
   - 3 cargos
   - 3 colaboradores
   - 1 usuário admin
   - Tabelas de impostos (INSS e IRRF 2024)

## Passo 4: Depois de executar o SQL

Volte para o terminal do Codespaces e execute:

```bash
pnpm dev
```

Pronto! A aplicação vai rodar em:
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001

## Login para testar

**Email:** admin@orbitdemo.com.br
**Senha:** admin123

---

## ⚠️ Troubleshooting

Se der erro ao executar o SQL:

1. **Erro: "relation already exists"**
   - Significa que você já executou o SQL antes
   - Solução: Ignore o erro OU delete as tabelas existentes antes

2. **Erro: "permission denied"**
   - Verifique se está usando a senha correta do Supabase
   - A senha no .env deve ser: `Le28042022`

3. **Timeout ou conexão lenta**
   - Tente executar novamente
   - O SQL é grande, pode demorar ~30 segundos
