# 🚀 Como Configurar com Supabase

## Por que usar Supabase?

✅ Não precisa rodar PostgreSQL localmente (Docker)
✅ Banco de dados na nuvem (sempre disponível)
✅ Backups automáticos
✅ Interface visual para ver os dados
✅ Autenticação built-in (opcional)
✅ Storage para arquivos

## 📋 Passo a Passo

### 1️⃣ Pegar Credenciais do Supabase

Acesse: https://app.supabase.com/project/darrtoexfebfbmzyubxf

#### a) Connection String do PostgreSQL

1. Vá em **Project Settings** (⚙️)
2. Clique em **Database**
3. Role até **Connection string**
4. Copie a **Connection pooling** ou **Direct connection**

**Formato:**
```
postgresql://postgres:[SUA-SENHA]@db.darrtoexfebfbmzyubxf.supabase.co:5432/postgres
```

⚠️ **Substitua `[SUA-SENHA]`** pela senha real que você criou no Supabase!

**Não sabe a senha?**
- Se esqueceu, você pode resetar em **Project Settings → Database → Database password → Reset**

#### b) Chaves do Frontend (você já tem!)

```
NEXT_PUBLIC_SUPABASE_URL=https://darrtoexfebfbmzyubxf.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...
```

### 2️⃣ Configurar o .env

```bash
# Copie o exemplo do Supabase
cp .env.supabase.example .env

# Edite o arquivo .env
nano .env
```

**Substitua a linha:**
```env
DATABASE_URL="postgresql://postgres:[YOUR_PASSWORD]@db.darrtoexfebfbmzyubxf.supabase.co:5432/postgres"
```

Pela connection string real com sua senha.

### 3️⃣ Redis (Escolha uma opção)

#### Opção A: Redis Local (Docker)
```bash
# Mantenha apenas o Redis no Docker
docker-compose up -d redis

# No .env:
REDIS_HOST="localhost"
REDIS_PORT=6379
REDIS_PASSWORD="orbit_redis_password"
```

#### Opção B: Upstash Redis (Serverless - Recomendado)

1. Acesse: https://upstash.com/
2. Crie um banco Redis grátis
3. Copie a **UPSTASH_REDIS_REST_URL**

```env
REDIS_URL="redis://default:[password]@[endpoint]:6379"
```

### 4️⃣ Instalar Dependências

```bash
pnpm install
```

### 5️⃣ Rodar Migrations no Supabase

```bash
# Gera o Prisma Client
pnpm db:generate

# Executa migrations (cria tabelas no Supabase)
pnpm db:migrate

# Popula com dados demo
pnpm db:seed
```

### 6️⃣ Iniciar Aplicação

```bash
pnpm dev
```

Acesse: http://localhost:3000

---

## ✅ Vantagens de usar Supabase

### Sem Docker Local
- ❌ Não precisa: `pnpm docker:up`
- ❌ Não precisa: PostgreSQL local
- ✅ Apenas Redis local (ou Upstash)

### Ver Dados Visualmente

Acesse o Supabase Dashboard:
https://app.supabase.com/project/darrtoexfebfbmzyubxf/editor

Você verá todas as tabelas:
- companies
- users
- employees
- departments
- etc.

### Backups Automáticos
Supabase faz backup automático do banco.

---

## 🔄 Migrar do PostgreSQL Local para Supabase

Se você já rodou com Docker local:

### 1. Exportar dados locais (opcional)
```bash
# Se quiser salvar dados locais
pg_dump -h localhost -U orbit orbit_dev > backup.sql
```

### 2. Parar Docker
```bash
pnpm docker:down
```

### 3. Configurar Supabase
Siga os passos acima.

### 4. Rodar migrations no Supabase
```bash
pnpm db:migrate
pnpm db:seed
```

### 5. Importar dados antigos (se quiser)
```bash
# No Supabase SQL Editor
# Cole o conteúdo de backup.sql
```

---

## 🐛 Troubleshooting

### Erro: "password authentication failed"
- Verifique se a senha está correta no `DATABASE_URL`
- Resete a senha no Supabase se necessário

### Erro: "connection timeout"
- Verifique se o IP está liberado no Supabase
- Vá em **Project Settings → Database → Connection pooling**
- Certifique-se que está usando **Connection pooling** (mais estável)

### Ver logs de erro do Prisma
```bash
# Modo verbose
DATABASE_URL="..." npx prisma migrate dev --name init
```

---

## 📊 Comparação

| Feature | PostgreSQL Local | Supabase |
|---------|------------------|----------|
| Setup | Docker required | ✅ Zero setup |
| Backup | Manual | ✅ Automático |
| GUI | pgAdmin | ✅ Built-in |
| Custo | Grátis | ✅ Grátis (Free tier) |
| Produção | Precisa deploy | ✅ Já está pronto |
| Performance | Rápido (local) | Rede (pode ser mais lento) |

---

## 🎯 Próximos Passos

Depois de configurar:

1. ✅ Supabase conectado
2. ✅ Migrations rodadas
3. ✅ Seed executado
4. ✅ Aplicação funcionando

**Opcional:** Usar Supabase Auth
- Você pode trocar nossa autenticação JWT custom
- Pela autenticação do Supabase
- Mais rápido de implementar
- Funcionalidades extras (social login, email verification, etc)

---

## 📞 Me envie para continuar

Para eu te ajudar a configurar completamente, me envie:

1. ✅ **NEXT_PUBLIC_SUPABASE_URL** (você já enviou)
2. ✅ **NEXT_PUBLIC_SUPABASE_ANON_KEY** (você já enviou)
3. ❓ **DATABASE_URL** (connection string do PostgreSQL)
   - Ou a senha do banco de dados

Assim eu configuro tudo para você! 🚀
