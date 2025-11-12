# Setup Guide - Orbit ERP

## 📋 Pré-requisitos

Certifique-se de ter instalado:

- **Node.js** >= 20.10.0 ([Download](https://nodejs.org/))
- **pnpm** >= 8.0.0 (`npm install -g pnpm`)
- **Docker** & **Docker Compose** ([Download](https://www.docker.com/))
- **Git** ([Download](https://git-scm.com/))

## 🚀 Setup Inicial

### 1. Clone o Repositório

```bash
git clone https://github.com/seu-usuario/orbit.git
cd orbit
```

### 2. Instale as Dependências

```bash
pnpm install
```

### 3. Configure as Variáveis de Ambiente

```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações locais (as configurações padrão já funcionam para desenvolvimento local).

### 4. Inicie os Serviços (PostgreSQL + Redis)

```bash
pnpm docker:up
```

Isso irá iniciar:
- PostgreSQL na porta `5432`
- Redis na porta `6379`
- pgAdmin na porta `5050` (opcional)

Para ver os logs:
```bash
pnpm docker:logs
```

Para parar os serviços:
```bash
pnpm docker:down
```

### 5. Configure o Banco de Dados

```bash
# Gerar Prisma Client
pnpm db:generate

# Executar migrations
pnpm db:migrate

# Popular com dados iniciais
pnpm db:seed
```

### 6. Inicie o Projeto

```bash
# Iniciar todos os apps (web + api)
pnpm dev

# Ou individualmente:
pnpm dev:web  # Frontend (porta 3000)
pnpm dev:api  # Backend (porta 3001)
```

## 🔧 Comandos Úteis

### Desenvolvimento

```bash
pnpm dev              # Inicia frontend + backend
pnpm dev:web          # Inicia apenas frontend
pnpm dev:api          # Inicia apenas backend
pnpm lint             # Executa linter
pnpm lint:fix         # Corrige problemas do linter
pnpm format           # Formata código com Prettier
pnpm type-check       # Verifica tipos TypeScript
```

### Database

```bash
pnpm db:generate      # Gera Prisma Client
pnpm db:migrate       # Cria nova migration
pnpm db:push          # Push schema sem migration (dev only)
pnpm db:seed          # Popula banco com dados iniciais
pnpm db:studio        # Abre Prisma Studio (GUI)
pnpm db:reset         # Reseta banco completamente
```

### Docker

```bash
pnpm docker:up        # Inicia containers
pnpm docker:down      # Para containers
pnpm docker:logs      # Mostra logs
```

### Build

```bash
pnpm build            # Build de produção
pnpm build:web        # Build apenas frontend
pnpm build:api        # Build apenas backend
```

### Testes

```bash
pnpm test             # Executa todos os testes
pnpm test:coverage    # Testes com coverage
pnpm test:e2e         # Testes end-to-end
```

## 🗄️ Acessando os Serviços

### Frontend (Next.js)
```
http://localhost:3000
```

### Backend API (Fastify)
```
http://localhost:3001
API Docs: http://localhost:3001/docs (quando implementado)
```

### Prisma Studio
```bash
pnpm db:studio
# Abre em: http://localhost:5555
```

### pgAdmin (Database Management)
```
http://localhost:5050
Email: admin@orbit.local
Password: admin
```

### Redis Commander
```bash
docker-compose --profile tools up redis-commander
# Abre em: http://localhost:8081
```

## 👤 Credenciais Padrão (Seed)

Após executar `pnpm db:seed`, você pode fazer login com:

**Email:** `admin@techsol.com.br`
**Password:** `orbit123`

## 🐛 Troubleshooting

### Porta já em uso

Se as portas 3000, 3001, 5432 ou 6379 já estiverem em uso:

```bash
# Linux/Mac: Encontrar processo
lsof -i :3000

# Windows: Encontrar processo
netstat -ano | findstr :3000

# Matar processo
kill -9 <PID>
```

Ou edite as portas no `docker-compose.yml` e `.env`.

### Erro no Prisma

```bash
# Limpar e reinstalar
rm -rf node_modules packages/*/node_modules
pnpm install
pnpm db:generate
```

### Container não inicia

```bash
# Limpar volumes Docker
docker-compose down -v

# Rebuild containers
docker-compose up --build -d
```

### Erro de permissão no Linux

```bash
# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Logout e login novamente
```

## 📚 Próximos Passos

1. ✅ Setup concluído
2. 🎨 Familiarize-se com a estrutura do projeto
3. 📖 Leia a [documentação](./docs/)
4. 🚀 Comece a desenvolver!

## 🤝 Suporte

- 📧 Email: dev@orbit.app
- 💬 Slack: [Link do Slack]
- 📖 Docs: [./docs/](./docs/)

---

**Problemas?** Abra uma issue no GitHub ou pergunte no canal de desenvolvimento.
