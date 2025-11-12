# Arquitetura Técnica - Orbit ERP

## 🏗️ Visão Geral da Arquitetura

### Arquitetura Escolhida: **Monolito Modular Moderno**

**Justificativa**:
- ✅ Simplicidade de deploy e manutenção inicial
- ✅ Menos complexidade operacional para MVP
- ✅ Latência reduzida (comunicação in-process)
- ✅ Transações ACID facilitadas
- ✅ Possibilidade de migração gradual para microserviços no futuro
- ✅ Ideal para equipe pequena (3-5 devs)

**Princípios Arquiteturais**:
1. **Separação de Concerns**: Módulos bem definidos e desacoplados
2. **Domain-Driven Design**: Lógica de negócio isolada
3. **Clean Architecture**: Inversão de dependências
4. **API-First**: Todas as operações via API (facilita futuro mobile)
5. **Multi-tenancy**: Isolamento total de dados por empresa

---

## 🛠️ Stack Tecnológico

### Frontend

#### Framework: **Next.js 14+ (App Router)**
**Por quê?**
- ✅ React com SSR/SSG out-of-the-box
- ✅ Roteamento file-based intuitivo
- ✅ Otimizações automáticas de performance
- ✅ TypeScript first-class
- ✅ API Routes integradas
- ✅ Melhor SEO (importante para landing page)

**Alternativas consideradas**: Remix, Nuxt.js, Vite + React
**Decisão**: Next.js por maturidade e ecossistema

#### Linguagem: **TypeScript 5+**
- Type safety completo
- Refatoração segura
- Melhor DX com autocomplete

#### Estilização: **Tailwind CSS 3+ + shadcn/ui**
**Por quê?**
- ✅ Utility-first (produtividade)
- ✅ Consistência visual
- ✅ shadcn/ui: componentes prontos e customizáveis
- ✅ Sem CSS-in-JS runtime (performance)
- ✅ Dark mode fácil

**Componentes**: shadcn/ui (Radix UI + Tailwind)
- Acessibilidade (WCAG 2.1)
- Componentes headless customizáveis
- Sem lock-in de biblioteca

#### Gerenciamento de Estado: **Zustand + React Query**
- **Zustand**: Estado global leve e simples
- **React Query (TanStack Query)**: Cache de API, sincronização, otimistic updates
- **React Hook Form**: Formulários performáticos

#### Tabelas: **TanStack Table (React Table v8)**
- Headless (controle total)
- Virtual scrolling (performance)
- Filtros, sort, paginação built-in

#### Gráficos: **Recharts**
- Declarativo (React-first)
- Responsivo
- Customizável

#### Datas: **date-fns**
- Tree-shakeable
- Leve (vs Moment.js)
- Boa localização PT-BR

### Backend

#### Framework: **Node.js + Fastify**
**Por quê?**
- ✅ Performance superior ao Express (2-3x mais rápido)
- ✅ TypeScript first-class
- ✅ Validação de schema built-in (JSON Schema)
- ✅ Plugins robustos
- ✅ Async/await nativo

**Alternativas consideradas**: NestJS, Express, Hono
**Decisão**: Fastify (performance + simplicidade sem overhead do NestJS)

#### Linguagem: **TypeScript 5+**
- Compartilhamento de tipos com frontend
- Type safety em runtime com Zod

#### Validação: **Zod**
- Schema validation com inferência de tipos
- Integração perfeita com TypeScript
- Validação em runtime

#### ORM: **Prisma**
**Por quê?**
- ✅ Type-safe query builder
- ✅ Migrações automáticas
- ✅ Schema declarativo
- ✅ Suporte multi-database
- ✅ Prisma Studio (GUI para dev)
- ✅ Excelente DX

**Alternativas consideradas**: TypeORM, Drizzle, Kysely
**Decisão**: Prisma por DX superior e type safety

#### Autenticação: **NextAuth.js (Auth.js)**
- Estratégias múltiplas (credentials, OAuth)
- Session management
- JWT + Database sessions
- Integração nativa com Next.js

#### Autorização: **CASL**
- RBAC flexível
- Attribute-based access control
- Type-safe permissions

### Banco de Dados

#### Relacional: **PostgreSQL 16+**
**Por quê?**
- ✅ ACID completo (crítico para folha de pagamento)
- ✅ Suporte a JSON (flexibilidade para tabelas dinâmicas)
- ✅ Particionamento de tabelas (escalabilidade)
- ✅ Row-level security (multi-tenancy)
- ✅ CTEs e window functions (relatórios complexos)
- ✅ Extensões (pg_cron para jobs)

**Estratégia Multi-tenancy**: Row-level security com `tenant_id`
- Pool de conexão compartilhado
- Índices por tenant
- Particionamento por tenant em tabelas grandes

#### Cache: **Redis 7+**
**Usos**:
- Session storage
- Cache de queries frequentes (tabelas tributárias)
- Rate limiting
- Pub/sub (notificações em tempo real)
- Background jobs queue (BullMQ)

#### Storage: **S3-compatible (AWS S3 / MinIO)**
**Usos**:
- Upload de documentos (RG, CPF, contratos)
- Fotos de perfil
- Holerites gerados
- Backups

### Infraestrutura

#### Containerização: **Docker + Docker Compose**
- Ambiente dev idêntico ao prod
- Isolamento de serviços
- Facilita CI/CD

#### Hospedagem: **Railway / Fly.io / Render (MVP) → AWS (Scale)**
**MVP**:
- **Frontend**: Vercel (Next.js otimizado)
- **Backend**: Railway / Render (Node.js + PostgreSQL)
- **Cache**: Upstash Redis (serverless)
- **Storage**: AWS S3

**Produção (Scale)**:
- **Frontend**: Vercel ou Cloudfront + S3
- **Backend**: ECS Fargate ou EC2 com Auto Scaling
- **Database**: RDS PostgreSQL Multi-AZ
- **Cache**: ElastiCache Redis
- **Storage**: S3
- **CDN**: CloudFront
- **Monitoramento**: CloudWatch + Sentry

#### CI/CD: **GitHub Actions**
```yaml
Workflows:
- Lint & Type Check
- Unit Tests
- Integration Tests
- Build Docker Image
- Deploy to Staging (auto)
- Deploy to Production (manual approval)
```

#### Monitoramento: **Sentry + Better Stack (Logtail)**
- **Sentry**: Error tracking, performance monitoring
- **Better Stack**: Logs centralizados, uptime monitoring
- **Posthog**: Analytics de produto (opcional)

---

## 🏛️ Estrutura de Módulos (Backend)

```
src/
├── modules/
│   ├── auth/                    # Autenticação e autorização
│   │   ├── auth.service.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.routes.ts
│   │   └── guards/
│   │
│   ├── employees/               # Gestão de colaboradores
│   │   ├── employee.service.ts
│   │   ├── employee.controller.ts
│   │   ├── employee.repository.ts
│   │   ├── employee.routes.ts
│   │   └── dto/
│   │
│   ├── payroll/                 # Folha de pagamento
│   │   ├── payroll.service.ts
│   │   ├── payroll-calculator.service.ts
│   │   ├── payroll.controller.ts
│   │   ├── payroll.routes.ts
│   │   └── calculators/
│   │       ├── inss.calculator.ts
│   │       ├── irrf.calculator.ts
│   │       ├── fgts.calculator.ts
│   │       └── overtime.calculator.ts
│   │
│   ├── timeclock/               # Ponto eletrônico
│   │   ├── timeclock.service.ts
│   │   ├── timeclock.controller.ts
│   │   ├── timeclock.routes.ts
│   │   └── validators/
│   │
│   ├── benefits/                # Benefícios
│   │   ├── benefit.service.ts
│   │   ├── benefit.controller.ts
│   │   ├── benefit.routes.ts
│   │   └── types/
│   │
│   ├── performance/             # Avaliação de desempenho
│   │   ├── evaluation.service.ts
│   │   ├── evaluation.controller.ts
│   │   └── evaluation.routes.ts
│   │
│   ├── social-feed/             # Feed social
│   │   ├── post.service.ts
│   │   ├── post.controller.ts
│   │   └── post.routes.ts
│   │
│   ├── reports/                 # Relatórios
│   │   ├── report.service.ts
│   │   ├── report.controller.ts
│   │   └── generators/
│   │
│   └── tax-tables/              # Tabelas tributárias
│       ├── tax-table.service.ts
│       ├── tax-table.controller.ts
│       └── tax-table.routes.ts
│
├── shared/                      # Código compartilhado
│   ├── database/
│   │   ├── prisma.service.ts
│   │   └── migrations/
│   ├── cache/
│   │   └── redis.service.ts
│   ├── storage/
│   │   └── s3.service.ts
│   ├── email/
│   │   └── email.service.ts
│   ├── pdf/
│   │   └── pdf.service.ts
│   └── utils/
│       ├── date.utils.ts
│       ├── validation.utils.ts
│       └── tenant.utils.ts
│
├── core/                        # Core do framework
│   ├── config/
│   │   └── app.config.ts
│   ├── middleware/
│   │   ├── auth.middleware.ts
│   │   ├── tenant.middleware.ts
│   │   ├── error-handler.middleware.ts
│   │   └── rate-limit.middleware.ts
│   └── decorators/
│
└── app.ts                       # Entry point
```

---

## 🏛️ Estrutura de Páginas (Frontend)

```
app/
├── (auth)/                      # Grupo de autenticação
│   ├── login/
│   ├── register/
│   └── forgot-password/
│
├── (dashboard)/                 # Grupo autenticado
│   ├── layout.tsx              # Layout com sidebar
│   │
│   ├── dashboard/              # Home
│   │   └── page.tsx
│   │
│   ├── employees/              # Colaboradores
│   │   ├── page.tsx           # Lista
│   │   ├── [id]/
│   │   │   ├── page.tsx       # Detalhes
│   │   │   └── edit/
│   │   └── new/
│   │
│   ├── payroll/                # Folha de pagamento
│   │   ├── page.tsx           # Dashboard
│   │   ├── calculate/
│   │   ├── history/
│   │   └── reports/
│   │
│   ├── timeclock/              # Ponto
│   │   ├── page.tsx           # Registro
│   │   ├── timesheet/         # Espelho
│   │   └── adjustments/       # Ajustes
│   │
│   ├── benefits/               # Benefícios
│   │   ├── page.tsx
│   │   └── [id]/
│   │
│   ├── performance/            # Avaliação
│   │   ├── cycles/
│   │   ├── evaluations/
│   │   └── reports/
│   │
│   ├── feed/                   # Feed social
│   │   └── page.tsx
│   │
│   ├── reports/                # Relatórios
│   │   └── page.tsx
│   │
│   └── settings/               # Configurações
│       ├── company/
│       ├── tax-tables/
│       └── users/
│
├── api/                         # API routes (se necessário)
│   └── webhook/
│
└── layout.tsx                   # Root layout
```

---

## 📊 Modelo de Dados (Resumido)

### Entidades Principais

```prisma
// schema.prisma

model Company {
  id              String   @id @default(cuid())
  name            String
  cnpj            String   @unique
  taxRegime       TaxRegime
  employees       Employee[]
  payrolls        Payroll[]
  benefits        Benefit[]
  // ... outros campos
}

model Employee {
  id              String   @id @default(cuid())
  companyId       String
  company         Company  @relation(fields: [companyId])

  // Dados pessoais
  name            String
  cpf             String
  email           String
  phone           String
  birthDate       DateTime

  // Dados contratuais
  registration    String   // Matrícula
  role            String
  department      String
  salary          Decimal
  admissionDate   DateTime
  contractType    ContractType

  // Relacionamentos
  timeclockRecords TimeclockRecord[]
  payrollEntries   PayrollEntry[]
  evaluations      Evaluation[]

  @@unique([companyId, cpf])
  @@index([companyId])
}

model TimeclockRecord {
  id          String   @id @default(cuid())
  companyId   String
  employeeId  String
  employee    Employee @relation(fields: [employeeId])

  timestamp   DateTime
  type        RecordType  // ENTRY, LUNCH_OUT, LUNCH_IN, EXIT
  source      Source      // WEB, MOBILE, BIOMETRIC
  location    Json?       // Geolocation
  ipAddress   String?

  @@index([companyId, employeeId, timestamp])
}

model Payroll {
  id              String   @id @default(cuid())
  companyId       String
  company         Company  @relation(fields: [companyId])

  referenceMonth  DateTime
  status          PayrollStatus  // DRAFT, CALCULATED, CLOSED
  closedAt        DateTime?
  closedBy        String?

  entries         PayrollEntry[]

  @@unique([companyId, referenceMonth])
}

model PayrollEntry {
  id              String   @id @default(cuid())
  payrollId       String
  payroll         Payroll  @relation(fields: [payrollId])
  employeeId      String
  employee        Employee @relation(fields: [employeeId])

  // Proventos
  baseSalary      Decimal
  overtime        Decimal  @default(0)
  commission      Decimal  @default(0)
  bonuses         Json?

  // Descontos
  inss            Decimal
  irrf            Decimal
  transportVoucher Decimal @default(0)
  others          Json?

  // Totais
  grossSalary     Decimal
  totalDeductions Decimal
  netSalary       Decimal

  // Encargos
  fgts            Decimal
  employerInss    Decimal

  @@index([payrollId, employeeId])
}

model TaxTable {
  id          String   @id @default(cuid())
  type        TaxType  // INSS, IRRF, FGTS
  startDate   DateTime
  endDate     DateTime?
  brackets    Json     // Array de faixas

  @@index([type, startDate])
}

model Benefit {
  id          String   @id @default(cuid())
  companyId   String
  company     Company  @relation(fields: [companyId])

  type        BenefitType
  name        String
  value       Decimal?
  percentage  Decimal?
  discountPercentage Decimal?

  eligibility Json     // Regras de elegibilidade
  active      Boolean  @default(true)
}

// ... mais modelos
```

**Ver documento completo**: [04-DATABASE.md](./04-DATABASE.md)

---

## 🔐 Segurança

### Autenticação
```typescript
// JWT + Database Sessions (híbrido)
- JWT para stateless APIs
- Session no Redis para web (melhor UX)
- Refresh tokens com rotação
- 2FA com TOTP (Authenticator apps)
```

### Autorização (RBAC + ABAC)
```typescript
Roles:
- SUPER_ADMIN: Acesso total (equipe Orbit)
- COMPANY_ADMIN: Admin da empresa
- HR_MANAGER: Gestão de RH
- MANAGER: Gestor de equipe
- EMPLOYEE: Colaborador

Permissions (exemplos):
- payroll:calculate
- payroll:view:own
- payroll:view:team
- payroll:view:all
- employee:create
- employee:edit
- timeclock:adjust:approve
```

### Multi-tenancy
```typescript
// Row-level security
middleware: injectTenant()
- Extrai tenant_id do JWT
- Injeta em todas as queries do Prisma
- Filtragem automática por company_id
- Previne data leakage entre empresas
```

### LGPD
```typescript
- Criptografia de campos sensíveis (CPF, RG, salário)
- Audit log de acessos
- Soft delete (paranoid mode)
- Data export (portabilidade)
- Anonymization jobs
```

---

## 🚀 Performance

### Frontend
- **Code Splitting**: Por rota e componente
- **Image Optimization**: Next.js Image component
- **Lazy Loading**: Componentes e modais
- **Virtual Scrolling**: Tabelas grandes (TanStack Virtual)
- **Memoization**: React.memo, useMemo, useCallback
- **Bundle Analysis**: Webpack Bundle Analyzer

### Backend
- **Database Indexing**: Índices compostos estratégicos
- **Query Optimization**: Select apenas campos necessários
- **N+1 Prevention**: Prisma eager loading
- **Caching**: Redis para queries frequentes (TTL: 5-60min)
- **Pagination**: Cursor-based para grandes datasets
- **Background Jobs**: BullMQ para processamentos pesados

### Database
```sql
-- Índices críticos
CREATE INDEX idx_timeclock_employee_date
  ON timeclock_records(company_id, employee_id, timestamp DESC);

CREATE INDEX idx_payroll_entries_lookup
  ON payroll_entries(payroll_id, employee_id)
  INCLUDE (net_salary);

-- Particionamento (futuro)
CREATE TABLE payroll_entries_2025_01
  PARTITION OF payroll_entries
  FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
```

---

## 📡 API Design

### REST API (Fastify)

**Padrão de URLs**:
```
GET    /api/v1/employees              # Lista
GET    /api/v1/employees/:id          # Detalhes
POST   /api/v1/employees              # Criar
PATCH  /api/v1/employees/:id          # Atualizar
DELETE /api/v1/employees/:id          # Deletar

GET    /api/v1/payroll/:month         # Folha do mês
POST   /api/v1/payroll/:month/calculate  # Calcular
POST   /api/v1/payroll/:month/close      # Fechar
```

**Response Pattern**:
```typescript
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150
  }
}

// Error
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "CPF inválido",
    "details": [...]
  }
}
```

### Versionamento
- URL-based: `/api/v1/`, `/api/v2/`
- Deprecation warnings nos headers

---

## 🧪 Testes

### Pirâmide de Testes
```
       /\
      /E2E\          10% - Playwright (critical paths)
     /------\
    /  API   \       30% - Supertest (endpoints)
   /----------\
  /   Unit     \     60% - Vitest (lógica de negócio)
 /--------------\
```

### Ferramentas
- **Unit/Integration**: Vitest
- **E2E**: Playwright
- **Coverage**: c8 (target: 80%+)
- **Mocking**: Vitest mocks + MSW (API mocking)

---

## 🔄 CI/CD Pipeline

```yaml
# .github/workflows/ci.yml

on: [push, pull_request]

jobs:
  test:
    - Checkout
    - Setup Node.js
    - Install dependencies
    - Lint (ESLint + Prettier)
    - Type check (tsc)
    - Unit tests (Vitest)
    - E2E tests (Playwright)
    - Upload coverage

  build:
    - Build frontend (Next.js)
    - Build backend (Docker)
    - Push to registry

  deploy-staging:
    if: branch == 'develop'
    - Deploy to staging
    - Run smoke tests

  deploy-production:
    if: branch == 'main'
    - Manual approval required
    - Deploy to production
    - Monitor Sentry
```

---

## 📈 Escalabilidade (Futuro)

### Quando migrar para Microserviços?
**Sinais**:
- 10.000+ empresas ativas
- Equipe > 15 desenvolvedores
- Módulos com ritmos de release diferentes
- Necessidade de escalar serviços individualmente

**Candidatos a Microserviços**:
1. **Calculation Engine**: Cálculos de folha (CPU-intensive)
2. **Report Generator**: Geração de PDFs (isolado)
3. **Notification Service**: Emails, push, SMS
4. **Integration Hub**: eSocial, contabilidade

### Database Scaling
- **Read Replicas**: Para relatórios
- **Partitioning**: Por company_id e data
- **Sharding**: Quando single DB não comportar

---

## 🎯 Decisões Arquiteturais (ADRs)

### ADR-001: Por que Monolito ao invés de Microserviços?
**Contexto**: MVP com equipe pequena
**Decisão**: Monolito modular
**Consequências**: Simplicidade operacional, deploy único, mas preparado para evolução

### ADR-002: Por que PostgreSQL ao invés de MongoDB?
**Contexto**: Dados financeiros críticos, transações ACID
**Decisão**: PostgreSQL
**Consequências**: Consistência garantida, joins eficientes, menos bugs em produção

### ADR-003: Por que Fastify ao invés de NestJS?
**Contexto**: Equipe experiente, preferência por controle e performance
**Decisão**: Fastify
**Consequências**: Performance superior, menos overhead, mas menos "baterias inclusas"

---

## 📚 Próximos Documentos

1. ✅ [01-CONCEPT.md](./01-CONCEPT.md)
2. ✅ [02-REQUIREMENTS.md](./02-REQUIREMENTS.md)
3. ✅ [03-ARCHITECTURE.md](./03-ARCHITECTURE.md) ← **Você está aqui**
4. ⏭️ [04-DATABASE.md](./04-DATABASE.md) - Schema completo do banco
5. ⏭️ [05-API.md](./05-API.md) - Documentação de todos os endpoints
6. ⏭️ [06-SETUP.md](./06-SETUP.md) - Como rodar o projeto

---

**Status**: Definição de Arquitetura Completa ✅
**Próximo Passo**: Modelar banco de dados completo
