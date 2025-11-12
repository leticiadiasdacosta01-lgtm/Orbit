# 🚀 RODAR ORBIT COM SUPABASE - GUIA COMPLETO

## ✅ Configuração Completa

Seu arquivo `.env` já está configurado com:
- ✅ Supabase PostgreSQL
- ✅ Suas chaves do Supabase
- ✅ Redis local simples
- ✅ JWT configurado

---

## 🏃 PASSO A PASSO PARA RODAR

### 1️⃣ Instalar Dependências

```bash
cd /home/user/Orbit
pnpm install
```

⏱️ Aguarde 2-3 minutos até aparecer "Done".

---

### 2️⃣ Iniciar Redis (Local e Simples)

**Opção A: Rodar Redis com Docker (Recomendado)**

```bash
docker run -d \
  --name orbit-redis \
  -p 6379:6379 \
  redis:7-alpine
```

**Verificar se está rodando:**
```bash
docker ps
```

Deve mostrar: `orbit-redis`

**Opção B: Se não quiser Docker**

Instale Redis localmente:
- **Ubuntu/Debian**: `sudo apt install redis-server && redis-server`
- **Mac**: `brew install redis && redis-server`

---

### 3️⃣ Configurar Banco de Dados (Supabase)

```bash
# Gera o Prisma Client
pnpm db:generate

# Cria as tabelas no Supabase
pnpm db:migrate

# Popula com dados demo
pnpm db:seed
```

**O que acontece:**
- ✅ Cria 15+ tabelas no Supabase
- ✅ Popula com empresa demo
- ✅ Cria usuário admin
- ✅ Cria 3 colaboradores
- ✅ Cria tabelas tributárias

**Você verá:**
```
🌱 Starting database seed...
✅ Company created: Tech Solutions Ltda
✅ Admin user created: admin@techsol.com.br
✅ Created 3 departments
✅ Created 3 roles
✅ Created 3 employees
✅ Created 3 benefits
🎉 Seed completed successfully!

📝 Login credentials:
   Email: admin@techsol.com.br
   Password: orbit123
```

---

### 4️⃣ Iniciar Aplicação

```bash
pnpm dev
```

**Você verá:**
```
> @orbit/api:dev: 🚀 Orbit API is running!
> @orbit/api:dev: 📍 URL: http://0.0.0.0:3001
> @orbit/api:dev: 🌍 Environment: development
> @orbit/api:dev: 📊 Database: Connected
> @orbit/api:dev: 🔴 Redis: Connected

> @orbit/web:dev: ▲ Next.js 14.0.4
> @orbit/web:dev: - Local:   http://localhost:3000
```

---

### 5️⃣ Acessar a Aplicação

Abra no navegador: **http://localhost:3000**

**Fazer Login:**
```
Email: admin@techsol.com.br
Senha: orbit123
```

---

## ✅ CHECKLIST - Está Funcionando?

- [ ] `pnpm install` rodou sem erros?
- [ ] Redis está rodando? (`docker ps` mostra orbit-redis)
- [ ] `pnpm db:migrate` criou as tabelas?
- [ ] `pnpm db:seed` populou os dados?
- [ ] `pnpm dev` está rodando?
- [ ] http://localhost:3000 abre?
- [ ] Consegue fazer login?
- [ ] Dashboard aparece?

**Se todos ✅ → SUCESSO!** 🎉

---

## 🗄️ Ver Dados no Supabase

Você pode ver todos os dados diretamente no Supabase:

1. Acesse: https://app.supabase.com/project/darrtoexfebfbmzyubxf/editor
2. Clique em **Table Editor**
3. Veja as tabelas:
   - `companies` → Empresas
   - `users` → Usuários
   - `employees` → Colaboradores
   - `departments` → Departamentos
   - etc.

---

## 🐛 PROBLEMAS COMUNS

### ❌ Erro: "Cannot connect to database"

**Solução:**
```bash
# Teste a conexão manualmente
psql "postgresql://postgres:Le28042022@db.darrtoexfebfbmzyubxf.supabase.co:5432/postgres"

# Se não conectar:
# 1. Verifique se a senha está correta no .env
# 2. Verifique se o IP está liberado no Supabase
```

### ❌ Erro: "Redis connection refused"

**Solução:**
```bash
# Ver se Redis está rodando
docker ps

# Se não estiver, inicie:
docker run -d --name orbit-redis -p 6379:6379 redis:7-alpine

# Teste a conexão
redis-cli ping
# Deve retornar: PONG
```

### ❌ Erro: "Port 3000 already in use"

**Solução:**
```bash
# Matar processo na porta 3000
lsof -ti:3000 | xargs kill -9

# Ou use outra porta
PORT=3002 pnpm dev:web
```

### ❌ Erro: "Prisma Client not generated"

**Solução:**
```bash
pnpm db:generate
```

### ❌ Erro no migration: "relation already exists"

**Solução:**
```bash
# Reseta as migrations (CUIDADO: apaga dados!)
pnpm db:reset

# Ou ignore (se as tabelas já existem)
# e rode apenas o seed:
pnpm db:seed
```

---

## 🎯 COMANDOS ÚTEIS

```bash
# Ver logs do Redis
docker logs orbit-redis

# Parar Redis
docker stop orbit-redis

# Remover Redis
docker rm orbit-redis

# Ver status do banco
pnpm db:studio
# Abre em: http://localhost:5555

# Rodar migrations de novo
pnpm db:migrate

# Popular dados de novo
pnpm db:seed

# Limpar tudo e recomeçar
pnpm db:reset
```

---

## 🌐 URLs IMPORTANTES

| Serviço | URL |
|---------|-----|
| **Frontend** | http://localhost:3000 |
| **Backend API** | http://localhost:3001 |
| **API Health** | http://localhost:3001/health |
| **Prisma Studio** | http://localhost:5555 (após `pnpm db:studio`) |
| **Supabase Dashboard** | https://app.supabase.com/project/darrtoexfebfbmzyubxf |
| **Supabase Table Editor** | https://app.supabase.com/project/darrtoexfebfbmzyubxf/editor |

---

## 🔥 TESTAR A API

### Health Check
```bash
curl http://localhost:3001/health
```

**Resposta:**
```json
{
  "status": "ok",
  "timestamp": "2025-01-15T10:00:00.000Z",
  "uptime": 45.123
}
```

### Login
```bash
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@techsol.com.br",
    "password": "orbit123"
  }'
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "user": { ... },
    "token": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

### Listar Colaboradores
```bash
# Copie o token da resposta acima e use aqui:
curl http://localhost:3001/api/v1/employees \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

---

## 📊 DADOS DISPONÍVEIS

Após o seed, você tem:

### Empresa
- **Nome:** Tech Solutions Ltda
- **CNPJ:** 12345678000199

### Usuário Admin
- **Email:** admin@techsol.com.br
- **Senha:** orbit123
- **Role:** COMPANY_ADMIN

### Colaboradores
1. **João Silva** - Desenvolvedor Full Stack
2. **Maria Santos** - Analista de RH
3. **Pedro Oliveira** - Vendedor

### Benefícios
1. Vale Transporte (VT)
2. Vale Refeição (VR)
3. Plano de Saúde Unimed

### Tabelas Tributárias 2025
- INSS
- IRRF
- FGTS

---

## 🎉 PRONTO!

Se você seguiu todos os passos e está funcionando, **PARABÉNS!** 🚀

Você tem:
- ✅ Backend rodando com Supabase
- ✅ Frontend com login funcional
- ✅ Dados demo populados
- ✅ Multi-tenancy configurado
- ✅ Autenticação JWT funcionando

---

## 📚 PRÓXIMOS PASSOS

Agora que está funcionando, você pode:

1. Explorar o dashboard
2. Ver os dados no Supabase
3. Testar a API
4. Começar a desenvolver novas features

**Quer implementar o CRUD completo de colaboradores?** Me avise!

---

**Problemas?** Me conte qual erro apareceu que te ajudo! 🆘
