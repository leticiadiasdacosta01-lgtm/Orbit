# 🚀 Quickstart - Orbit ERP

Guia rápido para rodar o projeto **AGORA**!

## ✅ O que já está pronto

- ✅ Backend Fastify com autenticação JWT
- ✅ Frontend Next.js 14 com login funcional
- ✅ PostgreSQL + Redis (Docker)
- ✅ Prisma com 15+ modelos
- ✅ Seed com dados demo
- ✅ Multi-tenancy configurado
- ✅ shadcn/ui components
- ✅ TypeScript em tudo

## 🏃 Como Rodar (5 minutos)

### 1. Instalar Dependências

```bash
pnpm install
```

### 2. Copiar .env

```bash
cp .env.example .env
```

### 3. Iniciar Serviços (Docker)

```bash
pnpm docker:up
```

Aguarde ~30 segundos para PostgreSQL e Redis iniciarem.

### 4. Configurar Banco de Dados

```bash
# Gerar Prisma Client
pnpm db:generate

# Executar migrations
pnpm db:migrate

# Popular com dados demo
pnpm db:seed
```

### 5. Iniciar Aplicação

```bash
# Inicia backend + frontend
pnpm dev
```

Ou individualmente:

```bash
pnpm dev:api  # Backend na porta 3001
pnpm dev:web  # Frontend na porta 3000
```

## 🎉 Acessar

### Frontend
```
http://localhost:3000
```

Será redirecionado para login automaticamente.

### Credenciais Demo

```
Email: admin@techsol.com.br
Senha: orbit123
```

### API
```
http://localhost:3001/health
http://localhost:3001/api/v1/auth/login
```

## 📊 Dados Demo (Seed)

Após o seed, você terá:

- 1 empresa: **Tech Solutions Ltda**
- 1 admin: admin@techsol.com.br
- 3 colaboradores:
  - João Silva (Desenvolvedor)
  - Maria Santos (Analista de RH)
  - Pedro Oliveira (Vendedor)
- 3 benefícios:
  - Vale Transporte
  - Vale Refeição
  - Plano de Saúde Unimed
- Tabelas tributárias 2025 (INSS, IRRF, FGTS)

## 🧪 Testar a API

### Login

```bash
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@techsol.com.br",
    "password": "orbit123"
  }'
```

### Listar Colaboradores (com token)

```bash
curl http://localhost:3001/api/v1/employees \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

## 🗄️ Acessar Banco de Dados

### Prisma Studio (GUI)

```bash
pnpm db:studio
```

Abre em: `http://localhost:5555`

### pgAdmin (Docker)

```bash
http://localhost:5050

Email: admin@orbit.local
Senha: admin
```

## 🛠️ Comandos Úteis

```bash
# Desenvolvimento
pnpm dev              # Tudo
pnpm dev:web          # Apenas frontend
pnpm dev:api          # Apenas backend

# Docker
pnpm docker:up        # Iniciar
pnpm docker:down      # Parar
pnpm docker:logs      # Ver logs

# Database
pnpm db:generate      # Gerar Prisma Client
pnpm db:migrate       # Nova migration
pnpm db:seed          # Seed de dados
pnpm db:studio        # GUI do banco
pnpm db:reset         # Resetar tudo (CUIDADO!)

# Qualidade
pnpm lint             # Lint
pnpm type-check       # TypeScript
pnpm format           # Prettier
```

## 🔥 Fluxo de Teste Completo

1. Acesse `http://localhost:3000`
2. Você será redirecionado para `/login`
3. Use as credenciais demo
4. Clique em "Entrar"
5. Você será redirecionado para `/dashboard`
6. Verá informações do usuário e cards de status
7. Clique em "Sair" para fazer logout

## 📁 Estrutura do Projeto

```
orbit/
├── apps/
│   ├── api/          ✅ Backend Fastify
│   └── web/          ✅ Frontend Next.js
├── packages/
│   ├── database/     ✅ Prisma
│   └── types/        ✅ TypeScript types
├── docs/             ✅ 6 documentos técnicos
└── docker-compose.yml ✅ PostgreSQL + Redis
```

## 🐛 Troubleshooting

### Porta 3000/3001 em uso

```bash
# Matar processo
lsof -ti:3000 | xargs kill -9
lsof -ti:3001 | xargs kill -9
```

### Erro no Prisma

```bash
rm -rf node_modules packages/*/node_modules
pnpm install
pnpm db:generate
```

### Docker não inicia

```bash
docker-compose down -v
docker-compose up --build -d
```

## 🎯 Próximos Passos

Agora que está rodando, você pode:

1. Explorar a API em `apps/api/src/modules/`
2. Criar novos componentes em `apps/web/src/components/`
3. Adicionar novas rotas em `apps/web/src/app/`
4. Expandir o schema em `packages/database/prisma/schema.prisma`

## 📚 Documentação Completa

- [README.md](./README.md) - Visão geral
- [SETUP.md](./SETUP.md) - Setup detalhado
- [docs/](./docs/) - Documentação técnica completa

## 🎊 Está Funcionando?

Se você conseguiu fazer login e ver o dashboard, **PARABÉNS!** 🎉

O Orbit ERP está rodando localmente e pronto para desenvolvimento!

---

**Problemas?** Abra uma issue ou consulte [SETUP.md](./SETUP.md)
