# 🚀 Como Rodar o Orbit ERP

## Pré-requisitos

Certifique-se de ter instalado:
- **Node.js** 20+ ([Download](https://nodejs.org/))
- **pnpm** 8+ (instale: `npm install -g pnpm`)
- **Docker** e **Docker Compose** ([Download](https://www.docker.com/))

## Passo a Passo (5 minutos)

### 1️⃣ Clone e entre no diretório (se ainda não fez)
```bash
cd Orbit
```

### 2️⃣ Instale as dependências
```bash
pnpm install
```

Isso vai instalar todas as dependências do monorepo (web, api, database, types).

### 3️⃣ Configure as variáveis de ambiente
```bash
cp .env.example .env
```

O `.env.example` já tem valores prontos para desenvolvimento local, então você pode usar sem alterar nada!

### 4️⃣ Inicie o PostgreSQL e Redis (Docker)
```bash
pnpm docker:up
```

Aguarde ~30 segundos para os serviços iniciarem. Você verá:
- ✅ PostgreSQL rodando na porta **5432**
- ✅ Redis rodando na porta **6379**

Para ver os logs:
```bash
pnpm docker:logs
```

### 5️⃣ Configure o banco de dados
```bash
# Gera o Prisma Client (tipos TypeScript)
pnpm db:generate

# Executa as migrations (cria as tabelas)
pnpm db:migrate

# Popula com dados de demonstração
pnpm db:seed
```

Após o seed, você terá:
- 1 empresa demo
- 1 usuário admin
- 3 colaboradores
- 3 benefícios
- Tabelas tributárias 2025

### 6️⃣ Inicie a aplicação
```bash
pnpm dev
```

Isso vai iniciar:
- 🌐 **Frontend** (Next.js): http://localhost:3000
- ⚡ **Backend** (Fastify): http://localhost:3001

## 🎉 Pronto!

Acesse: **http://localhost:3000**

### Credenciais de Login
```
Email: admin@techsol.com.br
Senha: orbit123
```

## 📊 Ferramentas Úteis

### Prisma Studio (Visualizar banco de dados)
```bash
pnpm db:studio
```
Abre em: http://localhost:5555

### pgAdmin (Gerenciar PostgreSQL)
Já está rodando no Docker:
- URL: http://localhost:5050
- Email: admin@orbit.local
- Senha: admin

## 🛑 Parar a Aplicação

### Parar Web e API
Pressione `Ctrl+C` no terminal onde rodou `pnpm dev`

### Parar Docker (PostgreSQL e Redis)
```bash
pnpm docker:down
```

## 🔄 Reiniciar do Zero

Se precisar limpar tudo e começar de novo:

```bash
# 1. Parar Docker
pnpm docker:down

# 2. Limpar volumes (deleta dados do banco)
docker-compose down -v

# 3. Limpar node_modules
pnpm clean
pnpm install

# 4. Subir Docker novamente
pnpm docker:up

# 5. Recriar banco
pnpm db:generate
pnpm db:migrate
pnpm db:seed

# 6. Iniciar aplicação
pnpm dev
```

## 📝 Comandos Úteis

```bash
# Desenvolvimento
pnpm dev              # Inicia tudo (web + api)
pnpm dev:web          # Apenas frontend
pnpm dev:api          # Apenas backend

# Docker
pnpm docker:up        # Inicia containers
pnpm docker:down      # Para containers
pnpm docker:logs      # Ver logs

# Database
pnpm db:generate      # Gera Prisma Client
pnpm db:migrate       # Nova migration
pnpm db:seed          # Popula dados demo
pnpm db:studio        # GUI do banco
pnpm db:reset         # Reseta banco (CUIDADO!)

# Build (Produção)
pnpm build            # Build de tudo
pnpm start            # Inicia em produção

# Qualidade de Código
pnpm lint             # Verifica erros
pnpm type-check       # Verifica tipos TypeScript
pnpm format           # Formata código com Prettier
```

## 🐛 Problemas Comuns

### Erro: "Port 3000 already in use"
```bash
# Encontre e mate o processo
lsof -ti:3000 | xargs kill -9
```

### Erro: "Cannot connect to PostgreSQL"
```bash
# Verifique se Docker está rodando
docker ps

# Se não estiver, inicie
pnpm docker:up

# Aguarde 30 segundos e tente novamente
```

### Erro: "Prisma Client not generated"
```bash
pnpm db:generate
```

### Erro de dependências
```bash
rm -rf node_modules packages/*/node_modules apps/*/node_modules
pnpm install
```

## 🎯 Estrutura de Portas

| Serviço | Porta | URL |
|---------|-------|-----|
| Frontend (Next.js) | 3000 | http://localhost:3000 |
| Backend (Fastify) | 3001 | http://localhost:3001 |
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |
| Prisma Studio | 5555 | http://localhost:5555 |
| pgAdmin | 5050 | http://localhost:5050 |

## ✅ Checklist de Sucesso

- [ ] `pnpm install` executado sem erros
- [ ] Docker iniciado com `pnpm docker:up`
- [ ] Migrations executadas com `pnpm db:migrate`
- [ ] Seed executado com `pnpm db:seed`
- [ ] `pnpm dev` rodando sem erros
- [ ] http://localhost:3000 abrindo a tela de login
- [ ] Login funcionando com credenciais demo
- [ ] Dashboard aparecendo após login

Se todos os itens estão ✅, **está funcionando perfeitamente!** 🎉

## 📚 Mais Informações

- Ver documentação completa: [README.md](./README.md)
- Setup detalhado: [SETUP.md](./SETUP.md)
- Guia rápido: [QUICKSTART.md](./QUICKSTART.md)
