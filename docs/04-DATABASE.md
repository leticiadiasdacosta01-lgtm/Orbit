# Modelo de Dados - Orbit ERP

## 🗄️ Visão Geral

**Banco de Dados**: PostgreSQL 16+
**ORM**: Prisma
**Estratégia Multi-tenancy**: Row-level security com `companyId`
**Soft Delete**: Habilitado em entidades críticas

---

## 📊 Schema Prisma Completo

```prisma
// schema.prisma

generator client {
  provider = "prisma-client-js"
  previewFeatures = ["fullTextSearch", "postgresqlExtensions"]
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// ============================================
// CORE - Empresas e Usuários
// ============================================

enum UserRole {
  SUPER_ADMIN      // Equipe Orbit
  COMPANY_ADMIN    // Admin da empresa
  HR_MANAGER       // Gestor de RH
  MANAGER          // Gestor de equipe
  EMPLOYEE         // Colaborador
}

enum TaxRegime {
  SIMPLES_NACIONAL
  LUCRO_PRESUMIDO
  LUCRO_REAL
}

model Company {
  id              String      @id @default(cuid())

  // Dados da empresa
  name            String
  tradeName       String?     // Nome fantasia
  cnpj            String      @unique
  stateRegistration String?   // Inscrição estadual
  municipalRegistration String? // Inscrição municipal

  // Endereço
  address         String
  addressNumber   String
  complement      String?
  neighborhood    String
  city            String
  state           String      @db.Char(2)
  zipCode         String      @db.Char(8)

  // Contato
  phone           String
  email           String
  website         String?

  // Configurações
  taxRegime       TaxRegime
  riskLevel       Int         @default(1) // RAT: 1%, 2% ou 3%
  paydayDay       Int         @default(5) // Dia do pagamento
  workHoursPerDay Decimal     @default(8) @db.Decimal(4,2)
  workDaysPerWeek Int         @default(5)
  toleranceMinutes Int        @default(10)

  // Customização
  logo            String?
  primaryColor    String      @default("#3B82F6")

  // Status
  active          Boolean     @default(true)
  trialEndsAt     DateTime?
  plan            String      @default("starter")

  // Timestamps
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt
  deletedAt       DateTime?

  // Relacionamentos
  users           User[]
  employees       Employee[]
  departments     Department[]
  roles           Role[]
  payrolls        Payroll[]
  benefits        Benefit[]
  holidays        Holiday[]
  posts           Post[]
  evaluationCycles EvaluationCycle[]

  @@index([cnpj])
  @@index([active])
}

model User {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  // Dados pessoais
  name            String
  email           String
  emailVerified   DateTime?
  password        String      // Hashed
  avatar          String?

  // Autenticação
  role            UserRole    @default(EMPLOYEE)
  twoFactorEnabled Boolean    @default(false)
  twoFactorSecret String?

  // Relacionamento com colaborador
  employeeId      String?     @unique
  employee        Employee?   @relation(fields: [employeeId], references: [id])

  // Status
  active          Boolean     @default(true)
  lastLoginAt     DateTime?

  // Timestamps
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  // Relacionamentos
  sessions        Session[]
  auditLogs       AuditLog[]

  @@unique([companyId, email])
  @@index([companyId, email])
}

model Session {
  id              String      @id @default(cuid())
  userId          String
  user            User        @relation(fields: [userId], references: [id], onDelete: Cascade)

  token           String      @unique
  refreshToken    String?     @unique
  expiresAt       DateTime

  ipAddress       String?
  userAgent       String?

  createdAt       DateTime    @default(now())

  @@index([userId])
  @@index([token])
}

// ============================================
// RH - Colaboradores e Estrutura
// ============================================

enum ContractType {
  CLT
  PJ
  INTERNSHIP       // Estágio
  TEMPORARY        // Temporário
  INTERMITTENT     // Intermitente
}

enum EmployeeStatus {
  ACTIVE
  ON_VACATION      // Em férias
  ON_LEAVE         // Afastado
  TERMINATED       // Desligado
}

enum Gender {
  MALE
  FEMALE
  OTHER
  PREFER_NOT_SAY
}

enum MaritalStatus {
  SINGLE
  MARRIED
  DIVORCED
  WIDOWED
  STABLE_UNION
}

model Department {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  name            String
  description     String?

  // Hierarquia
  parentId        String?
  parent          Department? @relation("DepartmentHierarchy", fields: [parentId], references: [id])
  children        Department[] @relation("DepartmentHierarchy")

  managerId       String?     @unique
  manager         Employee?   @relation("DepartmentManager", fields: [managerId], references: [id])

  active          Boolean     @default(true)

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  employees       Employee[]

  @@index([companyId])
}

model Role {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  name            String
  description     String?

  // CBO (Classificação Brasileira de Ocupações)
  cboCode         String?

  active          Boolean     @default(true)

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  employees       Employee[]

  @@unique([companyId, name])
  @@index([companyId])
}

model Employee {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  // Identificação
  registration    String      // Matrícula

  // Dados pessoais
  name            String
  cpf             String
  rg              String?
  rgIssuer        String?     // Órgão emissor
  rgIssueDate     DateTime?
  birthDate       DateTime
  gender          Gender?
  maritalStatus   MaritalStatus?
  nationality     String      @default("Brasileira")

  // Contato
  email           String?
  phone           String?
  personalEmail   String?

  // Endereço
  address         String?
  addressNumber   String?
  complement      String?
  neighborhood    String?
  city            String?
  state           String?     @db.Char(2)
  zipCode         String?     @db.Char(8)

  // Dados contratuais
  roleId          String
  role            Role        @relation(fields: [roleId], references: [id])
  departmentId    String
  department      Department  @relation(fields: [departmentId], references: [id])
  managedDepartment Department? @relation("DepartmentManager")

  contractType    ContractType
  admissionDate   DateTime
  terminationDate DateTime?

  // Salário
  salary          Decimal     @db.Decimal(10,2)
  salaryType      String      @default("MONTHLY") // MONTHLY, HOURLY

  // Jornada
  workSchedule    Json?       // Horários por dia da semana

  // Benefícios fiscais
  dependents      Int         @default(0)
  hasSpecialNeeds Boolean     @default(false)

  // Banco (para pagamento)
  bankCode        String?
  bankAgency      String?
  bankAccount     String?
  bankAccountType String?     // CHECKING, SAVINGS
  pixKey          String?

  // Documentos
  ctpsNumber      String?     // Carteira de trabalho
  ctpsSeries      String?
  pisPasep        String?
  voterRegistration String?

  // Fotos e documentos
  photo           String?
  documents       Json?       // Array de URLs

  // Status
  status          EmployeeStatus @default(ACTIVE)

  // Timestamps
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt
  deletedAt       DateTime?

  // Relacionamentos
  user            User?
  managerId       String?
  manager         Employee?   @relation("EmployeeManager", fields: [managerId], references: [id])
  subordinates    Employee[]  @relation("EmployeeManager")

  timeclockRecords TimeclockRecord[]
  payrollEntries   PayrollEntry[]
  leaves           Leave[]
  dependentsList   Dependent[]
  employeeBenefits EmployeeBenefit[]
  equipmentAssignments EquipmentAssignment[]
  evaluations      Evaluation[]

  @@unique([companyId, cpf])
  @@unique([companyId, registration])
  @@index([companyId, status])
  @@index([companyId, departmentId])
}

model Dependent {
  id              String      @id @default(cuid())
  employeeId      String
  employee        Employee    @relation(fields: [employeeId], references: [id], onDelete: Cascade)

  name            String
  cpf             String?
  birthDate       DateTime
  relationship    String      // FILHO, CONJUGE, ENTEADO, etc.

  // Para IRRF
  isIrrfDependent Boolean     @default(true)

  // Para plano de saúde
  includeInHealthPlan Boolean @default(false)

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@index([employeeId])
}

// ============================================
// PONTO ELETRÔNICO
// ============================================

enum RecordType {
  ENTRY           // Entrada
  LUNCH_OUT       // Saída almoço
  LUNCH_IN        // Retorno almoço
  EXIT            // Saída
  OVERTIME_ENTRY  // Entrada hora extra
  OVERTIME_EXIT   // Saída hora extra
}

enum RecordSource {
  WEB
  MOBILE
  BIOMETRIC
  MANUAL          // Ajuste manual
}

enum AdjustmentStatus {
  PENDING
  APPROVED
  REJECTED
}

model TimeclockRecord {
  id              String      @id @default(cuid())
  companyId       String
  employeeId      String
  employee        Employee    @relation(fields: [employeeId], references: [id])

  timestamp       DateTime
  type            RecordType
  source          RecordSource @default(WEB)

  // Metadados
  ipAddress       String?
  location        Json?       // { lat, lng, accuracy }
  deviceInfo      String?

  // Ajuste
  isAdjustment    Boolean     @default(false)
  adjustmentId    String?     @unique
  adjustment      TimeclockAdjustment? @relation(fields: [adjustmentId], references: [id])

  createdAt       DateTime    @default(now())

  @@index([companyId, employeeId, timestamp])
  @@index([timestamp])
}

model TimeclockAdjustment {
  id              String      @id @default(cuid())
  companyId       String
  employeeId      String

  // Dados da solicitação
  date            DateTime
  originalType    RecordType
  requestedTime   DateTime
  justification   String
  attachment      String?

  // Aprovação
  status          AdjustmentStatus @default(PENDING)
  reviewedBy      String?
  reviewedAt      DateTime?
  reviewComment   String?

  // Relacionamento com registro criado
  record          TimeclockRecord?

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@index([companyId, employeeId, status])
}

// ============================================
// FOLHA DE PAGAMENTO
// ============================================

enum PayrollStatus {
  DRAFT           // Rascunho
  CALCULATING     // Calculando
  CALCULATED      // Calculada
  APPROVED        // Aprovada
  PAID            // Paga
  CANCELLED       // Cancelada
}

model Payroll {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  // Período
  referenceMonth  DateTime    // Primeiro dia do mês (2025-01-01)

  // Status
  status          PayrollStatus @default(DRAFT)

  // Totalizadores
  totalEmployees  Int         @default(0)
  totalGross      Decimal     @default(0) @db.Decimal(12,2)
  totalNet        Decimal     @default(0) @db.Decimal(12,2)
  totalInss       Decimal     @default(0) @db.Decimal(12,2)
  totalIrrf       Decimal     @default(0) @db.Decimal(12,2)
  totalFgts       Decimal     @default(0) @db.Decimal(12,2)
  totalEmployerInss Decimal   @default(0) @db.Decimal(12,2)

  // Auditoria
  calculatedAt    DateTime?
  calculatedBy    String?
  approvedAt      DateTime?
  approvedBy      String?
  paidAt          DateTime?

  // Timestamps
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  // Relacionamentos
  entries         PayrollEntry[]

  @@unique([companyId, referenceMonth])
  @@index([companyId, status])
}

model PayrollEntry {
  id              String      @id @default(cuid())
  payrollId       String
  payroll         Payroll     @relation(fields: [payrollId], references: [id], onDelete: Cascade)
  employeeId      String
  employee        Employee    @relation(fields: [employeeId], references: [id])

  // Proventos (earnings)
  baseSalary      Decimal     @db.Decimal(10,2)
  overtime50      Decimal     @default(0) @db.Decimal(10,2)
  overtime100     Decimal     @default(0) @db.Decimal(10,2)
  nightShift      Decimal     @default(0) @db.Decimal(10,2)
  commission      Decimal     @default(0) @db.Decimal(10,2)
  bonus           Decimal     @default(0) @db.Decimal(10,2)
  dangerPay       Decimal     @default(0) @db.Decimal(10,2) // Periculosidade
  unhealthyPay    Decimal     @default(0) @db.Decimal(10,2) // Insalubridade
  otherEarnings   Json?       // Array de { description, value }

  // Descontos (deductions)
  inss            Decimal     @db.Decimal(10,2)
  irrf            Decimal     @db.Decimal(10,2)
  transportVoucher Decimal    @default(0) @db.Decimal(10,2)
  mealVoucher     Decimal     @default(0) @db.Decimal(10,2)
  healthPlan      Decimal     @default(0) @db.Decimal(10,2)
  dentalPlan      Decimal     @default(0) @db.Decimal(10,2)
  lifeInsurance   Decimal     @default(0) @db.Decimal(10,2)
  absence         Decimal     @default(0) @db.Decimal(10,2)
  advancePayment  Decimal     @default(0) @db.Decimal(10,2)
  otherDeductions Json?       // Array de { description, value }

  // Totais calculados
  grossSalary     Decimal     @db.Decimal(10,2)
  totalDeductions Decimal     @db.Decimal(10,2)
  netSalary       Decimal     @db.Decimal(10,2)

  // Encargos (employer costs)
  fgts            Decimal     @db.Decimal(10,2)
  employerInss    Decimal     @db.Decimal(10,2)
  rat             Decimal     @default(0) @db.Decimal(10,2) // Risco Ambiental Trabalho
  thirdParties    Decimal     @default(0) @db.Decimal(10,2) // Sistema S

  // Provisões
  vacationProvision Decimal   @db.Decimal(10,2)
  thirteenthProvision Decimal @db.Decimal(10,2)

  // Bases de cálculo
  inssBase        Decimal     @db.Decimal(10,2)
  irrfBase        Decimal     @db.Decimal(10,2)
  fgtsBase        Decimal     @db.Decimal(10,2)

  // Holerite
  payslipUrl      String?
  sentAt          DateTime?

  // Timestamps
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@unique([payrollId, employeeId])
  @@index([payrollId])
  @@index([employeeId])
}

// ============================================
// TABELAS TRIBUTÁRIAS
// ============================================

enum TaxType {
  INSS
  IRRF
  FGTS
}

model TaxTable {
  id              String      @id @default(cuid())

  type            TaxType
  startDate       DateTime
  endDate         DateTime?

  // Brackets (faixas)
  brackets        Json        // Array de { upTo, rate, deduction }

  // Exemplo INSS:
  // [
  //   { "upTo": 1412.00, "rate": 7.5, "deduction": 0 },
  //   { "upTo": 2666.68, "rate": 9.0, "deduction": 21.18 },
  //   { "upTo": 4000.03, "rate": 12.0, "deduction": 101.18 },
  //   { "upTo": 7786.02, "rate": 14.0, "deduction": 181.18 }
  // ]

  createdAt       DateTime    @default(now())

  @@index([type, startDate])
}

// ============================================
// BENEFÍCIOS
// ============================================

enum BenefitType {
  TRANSPORT_VOUCHER      // Vale-transporte
  MEAL_VOUCHER           // Vale-refeição
  FOOD_VOUCHER           // Vale-alimentação
  HEALTH_PLAN            // Plano de saúde
  DENTAL_PLAN            // Plano odontológico
  LIFE_INSURANCE         // Seguro de vida
  GYM                    // Academia
  EDUCATION              // Auxílio educação
  DAYCARE                // Auxílio creche
  OTHER                  // Outros
}

model Benefit {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  type            BenefitType
  name            String
  description     String?

  // Valores
  fixedValue      Decimal?    @db.Decimal(10,2)
  percentageValue Decimal?    @db.Decimal(5,2)

  // Desconto do colaborador
  employeeDiscountPercentage Decimal? @db.Decimal(5,2)
  employeeFixedDiscount      Decimal? @db.Decimal(10,2)

  // Elegibilidade
  eligibilityRules Json?      // { departments: [], roles: [], contractTypes: [] }

  // Provider
  providerName    String?
  providerContact String?

  active          Boolean     @default(true)

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  employeeBenefits EmployeeBenefit[]

  @@index([companyId, active])
}

model EmployeeBenefit {
  id              String      @id @default(cuid())
  employeeId      String
  employee        Employee    @relation(fields: [employeeId], references: [id], onDelete: Cascade)
  benefitId       String
  benefit         Benefit     @relation(fields: [benefitId], references: [id])

  // Valores específicos (override do benefício)
  customValue     Decimal?    @db.Decimal(10,2)
  customDiscount  Decimal?    @db.Decimal(10,2)

  // Dependentes inclusos
  includeDependents Boolean   @default(false)
  dependentsCount   Int       @default(0)

  startDate       DateTime
  endDate         DateTime?

  active          Boolean     @default(true)

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@unique([employeeId, benefitId])
  @@index([employeeId])
}

// ============================================
// FÉRIAS E AFASTAMENTOS
// ============================================

enum LeaveType {
  VACATION              // Férias
  SICK_LEAVE            // Atestado médico
  MATERNITY_LEAVE       // Licença maternidade
  PATERNITY_LEAVE       // Licença paternidade
  UNPAID_LEAVE          // Licença não remunerada
  ABSENCE               // Falta
  INSS_LEAVE            // Afastamento INSS
  OTHER
}

enum LeaveStatus {
  PENDING
  APPROVED
  REJECTED
  CANCELLED
}

model Leave {
  id              String      @id @default(cuid())
  companyId       String
  employeeId      String
  employee        Employee    @relation(fields: [employeeId], references: [id])

  type            LeaveType
  startDate       DateTime
  endDate         DateTime
  days            Int

  reason          String?
  attachment      String?     // URL do atestado/documento

  status          LeaveStatus @default(PENDING)

  reviewedBy      String?
  reviewedAt      DateTime?
  reviewComment   String?

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@index([companyId, employeeId])
  @@index([startDate, endDate])
}

// ============================================
// UNIFORMES E EPIs
// ============================================

enum EquipmentType {
  UNIFORM
  EPI                 // Equipamento de Proteção Individual
  TOOL                // Ferramenta
  ELECTRONICS         // Eletrônicos (notebook, celular)
  OTHER
}

model Equipment {
  id              String      @id @default(cuid())
  companyId       String

  type            EquipmentType
  name            String
  description     String?

  // EPI específico
  caNumber        String?     // Certificado de Aprovação
  caExpiryDate    DateTime?

  // Estoque
  quantity        Int         @default(0)
  minQuantity     Int         @default(0)

  // Valor
  unitCost        Decimal?    @db.Decimal(10,2)

  active          Boolean     @default(true)

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  assignments     EquipmentAssignment[]

  @@index([companyId, type])
}

model EquipmentAssignment {
  id              String      @id @default(cuid())
  companyId       String
  equipmentId     String
  equipment       Equipment   @relation(fields: [equipmentId], references: [id])
  employeeId      String
  employee        Employee    @relation(fields: [employeeId], references: [id])

  quantity        Int         @default(1)
  assignedAt      DateTime    @default(now())
  returnedAt      DateTime?

  // Assinatura digital
  signatureUrl    String?

  condition       String?     // NOVO, BOM, USADO
  notes           String?

  @@index([employeeId])
  @@index([equipmentId])
}

// ============================================
// AVALIAÇÃO DE DESEMPENHO
// ============================================

enum EvaluationType {
  SELF                // Autoavaliação
  MANAGER             // Avaliação por gestor
  PEER                // Avaliação por pares
  DEGREE_360          // 360 graus
}

enum EvaluationStatus {
  DRAFT
  IN_PROGRESS
  COMPLETED
  CANCELLED
}

model EvaluationCycle {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  name            String
  description     String?
  type            EvaluationType

  startDate       DateTime
  endDate         DateTime

  // Template
  competencies    Json        // Array de competências a avaliar

  status          EvaluationStatus @default(DRAFT)

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  evaluations     Evaluation[]

  @@index([companyId, status])
}

model Evaluation {
  id              String      @id @default(cuid())
  cycleId         String
  cycle           EvaluationCycle @relation(fields: [cycleId], references: [id])

  employeeId      String      // Avaliado
  employee        Employee    @relation(fields: [employeeId], references: [id])

  evaluatorId     String?     // Avaliador (null para autoavaliação)

  // Respostas
  answers         Json        // Array de { competencyId, score, comment }

  // Pontuação
  finalScore      Decimal?    @db.Decimal(5,2)

  // PDI
  developmentPlan String?

  status          EvaluationStatus @default(DRAFT)

  completedAt     DateTime?

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@index([cycleId, employeeId])
  @@index([employeeId])
}

// ============================================
// FEED SOCIAL
// ============================================

enum PostType {
  ANNOUNCEMENT        // Comunicado
  BIRTHDAY            // Aniversário
  ACHIEVEMENT         // Conquista
  WELCOME             // Boas-vindas
  POLL                // Enquete
  GENERAL             // Geral
}

model Post {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  authorId        String

  type            PostType    @default(GENERAL)
  content         String      @db.Text

  // Mídia
  images          Json?       // Array de URLs
  attachments     Json?       // Array de { name, url }

  // Visibilidade
  visibility      Json?       // { all: true } ou { departments: [], employees: [] }

  // Interações
  pinned          Boolean     @default(false)
  commentsEnabled Boolean     @default(true)

  // Timestamps
  publishedAt     DateTime    @default(now())
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt
  deletedAt       DateTime?

  // Relacionamentos
  likes           PostLike[]
  comments        PostComment[]

  @@index([companyId, publishedAt])
  @@index([companyId, pinned])
}

model PostLike {
  id              String      @id @default(cuid())
  postId          String
  post            Post        @relation(fields: [postId], references: [id], onDelete: Cascade)
  userId          String

  createdAt       DateTime    @default(now())

  @@unique([postId, userId])
  @@index([postId])
}

model PostComment {
  id              String      @id @default(cuid())
  postId          String
  post            Post        @relation(fields: [postId], references: [id], onDelete: Cascade)
  userId          String

  content         String      @db.Text

  // Respostas (thread)
  parentId        String?
  parent          PostComment? @relation("CommentReplies", fields: [parentId], references: [id])
  replies         PostComment[] @relation("CommentReplies")

  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt
  deletedAt       DateTime?

  @@index([postId])
}

// ============================================
// FERIADOS
// ============================================

enum HolidayType {
  NATIONAL
  STATE
  MUNICIPAL
  COMPANY         // Feriado interno da empresa
}

model Holiday {
  id              String      @id @default(cuid())
  companyId       String
  company         Company     @relation(fields: [companyId], references: [id])

  name            String
  date            DateTime
  type            HolidayType

  recurring       Boolean     @default(true) // Se repete todo ano

  createdAt       DateTime    @default(now())

  @@index([companyId, date])
}

// ============================================
// AUDITORIA
// ============================================

enum AuditAction {
  CREATE
  UPDATE
  DELETE
  VIEW
  EXPORT
  LOGIN
  LOGOUT
  CALCULATE_PAYROLL
  APPROVE_PAYROLL
  ADJUST_TIMECLOCK
}

model AuditLog {
  id              String      @id @default(cuid())
  companyId       String

  userId          String
  user            User        @relation(fields: [userId], references: [id])

  action          AuditAction
  entity          String      // Employee, Payroll, etc.
  entityId        String

  // Dados alterados
  oldValues       Json?
  newValues       Json?

  ipAddress       String?
  userAgent       String?

  createdAt       DateTime    @default(now())

  @@index([companyId, createdAt])
  @@index([userId])
  @@index([entity, entityId])
}
```

---

## 📊 Relacionamentos Principais

```
Company
├── Users (N)
├── Employees (N)
│   ├── TimeclockRecords (N)
│   ├── PayrollEntries (N)
│   ├── Dependents (N)
│   └── EmployeeBenefits (N)
├── Payrolls (N)
│   └── PayrollEntries (N)
├── Departments (N)
├── Roles (N)
├── Benefits (N)
└── Posts (N)
```

---

## 🔍 Índices Estratégicos

### Performance Crítica
```sql
-- Lookup de ponto por colaborador e período
CREATE INDEX idx_timeclock_employee_period
  ON timeclock_records(company_id, employee_id, timestamp DESC);

-- Lookup de folha por mês
CREATE INDEX idx_payroll_month
  ON payrolls(company_id, reference_month DESC);

-- Busca de colaboradores ativos
CREATE INDEX idx_employees_active
  ON employees(company_id, status) WHERE status = 'ACTIVE';

-- Feed social (posts recentes)
CREATE INDEX idx_posts_recent
  ON posts(company_id, published_at DESC) WHERE deleted_at IS NULL;
```

---

## 🔐 Row-Level Security (RLS)

```sql
-- Middleware Prisma: Sempre filtra por companyId
prisma.$use(async (params, next) => {
  const tenantId = getTenantIdFromContext();

  if (params.model && params.model !== 'TaxTable') {
    if (params.action === 'create') {
      params.args.data.companyId = tenantId;
    }

    if (['findMany', 'findFirst', 'update', 'delete'].includes(params.action)) {
      params.args.where = {
        ...params.args.where,
        companyId: tenantId,
      };
    }
  }

  return next(params);
});
```

---

## 📦 Migrações

### Setup Inicial
```bash
# Criar migration
npx prisma migrate dev --name init

# Gerar client
npx prisma generate

# Seed banco (dados iniciais)
npx prisma db seed
```

### Seed de Desenvolvimento
```typescript
// prisma/seed.ts
import { Prisma } from '@prisma/client'

async function seed() {
  // Criar tabelas tributárias padrão
  await createTaxTables()

  // Criar empresa de exemplo
  const company = await createDemoCompany()

  // Criar colaboradores de exemplo
  await createDemoEmployees(company.id)

  // Criar feriados nacionais 2025
  await createNationalHolidays(company.id)
}
```

---

## 🎯 Particionamento (Futuro)

### Quando particionar?
- Tabela > 100 GB
- Queries sempre filtram por data
- Performance degradando

### Candidatas
```sql
-- Particionar por mês
CREATE TABLE payroll_entries (
  ...
) PARTITION BY RANGE (created_at);

CREATE TABLE payroll_entries_2025_01 PARTITION OF payroll_entries
  FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
```

---

**Próximo**: [05-API.md](./05-API.md) - Documentação dos Endpoints
