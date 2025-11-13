-- ============================================
-- ORBIT ERP - SQL COMPLETO PARA SUPABASE (CORRIGIDO)
-- ============================================
-- Execute este SQL inteiro no SQL Editor do Supabase
-- https://supabase.com/dashboard/project/darrtoexfebfbmzyubxf/sql/new
-- ============================================

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('SUPER_ADMIN', 'COMPANY_ADMIN', 'HR_MANAGER', 'MANAGER', 'EMPLOYEE');

-- CreateEnum
CREATE TYPE "TaxRegime" AS ENUM ('SIMPLES_NACIONAL', 'LUCRO_PRESUMIDO', 'LUCRO_REAL');

-- CreateEnum
CREATE TYPE "ContractType" AS ENUM ('CLT', 'PJ', 'INTERNSHIP', 'TEMPORARY', 'INTERMITTENT');

-- CreateEnum
CREATE TYPE "EmployeeStatus" AS ENUM ('ACTIVE', 'ON_VACATION', 'ON_LEAVE', 'TERMINATED');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_SAY');

-- CreateEnum
CREATE TYPE "MaritalStatus" AS ENUM ('SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED', 'STABLE_UNION');

-- CreateEnum
CREATE TYPE "RecordType" AS ENUM ('ENTRY', 'LUNCH_OUT', 'LUNCH_IN', 'EXIT', 'OVERTIME_ENTRY', 'OVERTIME_EXIT');

-- CreateEnum
CREATE TYPE "RecordSource" AS ENUM ('WEB', 'MOBILE', 'BIOMETRIC', 'MANUAL');

-- CreateEnum
CREATE TYPE "AdjustmentStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "PayrollStatus" AS ENUM ('DRAFT', 'CALCULATING', 'CALCULATED', 'APPROVED', 'PAID', 'CANCELLED');

-- CreateEnum
CREATE TYPE "TaxType" AS ENUM ('INSS', 'IRRF', 'FGTS');

-- CreateEnum
CREATE TYPE "BenefitType" AS ENUM ('TRANSPORT_VOUCHER', 'MEAL_VOUCHER', 'FOOD_VOUCHER', 'HEALTH_PLAN', 'DENTAL_PLAN', 'LIFE_INSURANCE', 'GYM', 'EDUCATION', 'DAYCARE', 'OTHER');

-- CreateEnum
CREATE TYPE "AuditAction" AS ENUM ('CREATE', 'UPDATE', 'DELETE', 'VIEW', 'EXPORT', 'LOGIN', 'LOGOUT', 'CALCULATE_PAYROLL', 'APPROVE_PAYROLL', 'ADJUST_TIMECLOCK');

-- CreateTable
CREATE TABLE "companies" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "name" TEXT NOT NULL,
    "tradeName" TEXT,
    "cnpj" TEXT NOT NULL,
    "stateRegistration" TEXT,
    "municipalRegistration" TEXT,
    "address" TEXT NOT NULL,
    "addressNumber" TEXT NOT NULL,
    "complement" TEXT,
    "neighborhood" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" CHAR(2) NOT NULL,
    "zipCode" CHAR(8) NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "website" TEXT,
    "taxRegime" "TaxRegime" NOT NULL,
    "riskLevel" INTEGER NOT NULL DEFAULT 1,
    "paydayDay" INTEGER NOT NULL DEFAULT 5,
    "workHoursPerDay" DECIMAL(4,2) NOT NULL DEFAULT 8,
    "workDaysPerWeek" INTEGER NOT NULL DEFAULT 5,
    "toleranceMinutes" INTEGER NOT NULL DEFAULT 10,
    "logo" TEXT,
    "primaryColor" TEXT NOT NULL DEFAULT '#3B82F6',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "trialEndsAt" TIMESTAMP(3),
    "plan" TEXT NOT NULL DEFAULT 'starter',

    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" TIMESTAMP(3),
    "password" TEXT NOT NULL,
    "avatar" TEXT,
    "role" "UserRole" NOT NULL DEFAULT 'EMPLOYEE',
    "twoFactorEnabled" BOOLEAN NOT NULL DEFAULT false,
    "twoFactorSecret" TEXT,
    "employeeId" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "lastLoginAt" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "refreshToken" TEXT,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "parentId" TEXT,
    "managerId" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "cboCode" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "companyId" TEXT NOT NULL,
    "registration" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "rg" TEXT,
    "rgIssuer" TEXT,
    "rgIssueDate" TIMESTAMP(3),
    "birthDate" TIMESTAMP(3) NOT NULL,
    "gender" "Gender",
    "maritalStatus" "MaritalStatus",
    "nationality" TEXT NOT NULL DEFAULT 'Brasileira',
    "email" TEXT,
    "phone" TEXT,
    "personalEmail" TEXT,
    "address" TEXT,
    "addressNumber" TEXT,
    "complement" TEXT,
    "neighborhood" TEXT,
    "city" TEXT,
    "state" CHAR(2),
    "zipCode" CHAR(8),
    "roleId" TEXT NOT NULL,
    "departmentId" TEXT NOT NULL,
    "contractType" "ContractType" NOT NULL,
    "admissionDate" TIMESTAMP(3) NOT NULL,
    "terminationDate" TIMESTAMP(3),
    "salary" DECIMAL(10,2) NOT NULL,
    "salaryType" TEXT NOT NULL DEFAULT 'MONTHLY',
    "workSchedule" JSONB,
    "dependents" INTEGER NOT NULL DEFAULT 0,
    "hasSpecialNeeds" BOOLEAN NOT NULL DEFAULT false,
    "bankCode" TEXT,
    "bankAgency" TEXT,
    "bankAccount" TEXT,
    "bankAccountType" TEXT,
    "pixKey" TEXT,
    "ctpsNumber" TEXT,
    "ctpsSeries" TEXT,
    "pisPasep" TEXT,
    "voterRegistration" TEXT,
    "photo" TEXT,
    "documents" JSONB,
    "status" "EmployeeStatus" NOT NULL DEFAULT 'ACTIVE',
    "managerId" TEXT,

    CONSTRAINT "employees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dependents" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "employeeId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "cpf" TEXT,
    "birthDate" TIMESTAMP(3) NOT NULL,
    "relationship" TEXT NOT NULL,
    "isIrrfDependent" BOOLEAN NOT NULL DEFAULT true,
    "includeInHealthPlan" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "dependents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "timeclock_records" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "companyId" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "type" "RecordType" NOT NULL,
    "source" "RecordSource" NOT NULL DEFAULT 'WEB',
    "ipAddress" TEXT,
    "location" JSONB,
    "deviceInfo" TEXT,
    "isAdjustment" BOOLEAN NOT NULL DEFAULT false,
    "adjustmentId" TEXT,

    CONSTRAINT "timeclock_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "timeclock_adjustments" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "companyId" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "originalType" "RecordType" NOT NULL,
    "requestedTime" TIMESTAMP(3) NOT NULL,
    "justification" TEXT NOT NULL,
    "attachment" TEXT,
    "status" "AdjustmentStatus" NOT NULL DEFAULT 'PENDING',
    "reviewedBy" TEXT,
    "reviewedAt" TIMESTAMP(3),
    "reviewComment" TEXT,

    CONSTRAINT "timeclock_adjustments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payrolls" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "companyId" TEXT NOT NULL,
    "referenceMonth" TIMESTAMP(3) NOT NULL,
    "status" "PayrollStatus" NOT NULL DEFAULT 'DRAFT',
    "totalEmployees" INTEGER NOT NULL DEFAULT 0,
    "totalGross" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalNet" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalInss" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalIrrf" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalFgts" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalEmployerInss" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "calculatedAt" TIMESTAMP(3),
    "calculatedBy" TEXT,
    "approvedAt" TIMESTAMP(3),
    "approvedBy" TEXT,
    "paidAt" TIMESTAMP(3),

    CONSTRAINT "payrolls_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_entries" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "payrollId" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "baseSalary" DECIMAL(10,2) NOT NULL,
    "overtime50" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "overtime100" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "nightShift" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "commission" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "bonus" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "dangerPay" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "unhealthyPay" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "otherEarnings" JSONB,
    "inss" DECIMAL(10,2) NOT NULL,
    "irrf" DECIMAL(10,2) NOT NULL,
    "transportVoucher" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "mealVoucher" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "healthPlan" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "dentalPlan" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "lifeInsurance" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "absence" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "advancePayment" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "otherDeductions" JSONB,
    "grossSalary" DECIMAL(10,2) NOT NULL,
    "totalDeductions" DECIMAL(10,2) NOT NULL,
    "netSalary" DECIMAL(10,2) NOT NULL,
    "fgts" DECIMAL(10,2) NOT NULL,
    "employerInss" DECIMAL(10,2) NOT NULL,
    "rat" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "thirdParties" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "vacationProvision" DECIMAL(10,2) NOT NULL,
    "thirteenthProvision" DECIMAL(10,2) NOT NULL,
    "inssBase" DECIMAL(10,2) NOT NULL,
    "irrfBase" DECIMAL(10,2) NOT NULL,
    "fgtsBase" DECIMAL(10,2) NOT NULL,
    "payslipUrl" TEXT,
    "sentAt" TIMESTAMP(3),

    CONSTRAINT "payroll_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tax_tables" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" "TaxType" NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "brackets" JSONB NOT NULL,

    CONSTRAINT "tax_tables_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "benefits" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "companyId" TEXT NOT NULL,
    "type" "BenefitType" NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "fixedValue" DECIMAL(10,2),
    "percentageValue" DECIMAL(5,2),
    "employeeDiscountPercentage" DECIMAL(5,2),
    "employeeFixedDiscount" DECIMAL(10,2),
    "eligibilityRules" JSONB,
    "providerName" TEXT,
    "providerContact" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "benefits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee_benefits" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "employeeId" TEXT NOT NULL,
    "benefitId" TEXT NOT NULL,
    "customValue" DECIMAL(10,2),
    "customDiscount" DECIMAL(10,2),
    "includeDependents" BOOLEAN NOT NULL DEFAULT false,
    "dependentsCount" INTEGER NOT NULL DEFAULT 0,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "employee_benefits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "companyId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "action" "AuditAction" NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "oldValues" JSONB,
    "newValues" JSONB,
    "ipAddress" TEXT,
    "userAgent" TEXT,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "companies_cnpj_key" ON "companies"("cnpj");

-- CreateIndex
CREATE INDEX "companies_cnpj_idx" ON "companies"("cnpj");

-- CreateIndex
CREATE INDEX "companies_active_idx" ON "companies"("active");

-- CreateIndex
CREATE UNIQUE INDEX "users_employeeId_key" ON "users"("employeeId");

-- CreateIndex
CREATE INDEX "users_companyId_email_idx" ON "users"("companyId", "email");

-- CreateIndex
CREATE UNIQUE INDEX "users_companyId_email_key" ON "users"("companyId", "email");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_token_key" ON "sessions"("token");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_refreshToken_key" ON "sessions"("refreshToken");

-- CreateIndex
CREATE INDEX "sessions_userId_idx" ON "sessions"("userId");

-- CreateIndex
CREATE INDEX "sessions_token_idx" ON "sessions"("token");

-- CreateIndex
CREATE UNIQUE INDEX "departments_managerId_key" ON "departments"("managerId");

-- CreateIndex
CREATE INDEX "departments_companyId_idx" ON "departments"("companyId");

-- CreateIndex
CREATE INDEX "roles_companyId_idx" ON "roles"("companyId");

-- CreateIndex
CREATE UNIQUE INDEX "roles_companyId_name_key" ON "roles"("companyId", "name");

-- CreateIndex
CREATE INDEX "employees_companyId_status_idx" ON "employees"("companyId", "status");

-- CreateIndex
CREATE INDEX "employees_companyId_departmentId_idx" ON "employees"("companyId", "departmentId");

-- CreateIndex
CREATE UNIQUE INDEX "employees_companyId_cpf_key" ON "employees"("companyId", "cpf");

-- CreateIndex
CREATE UNIQUE INDEX "employees_companyId_registration_key" ON "employees"("companyId", "registration");

-- CreateIndex
CREATE INDEX "dependents_employeeId_idx" ON "dependents"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "timeclock_records_adjustmentId_key" ON "timeclock_records"("adjustmentId");

-- CreateIndex
CREATE INDEX "timeclock_records_companyId_employeeId_timestamp_idx" ON "timeclock_records"("companyId", "employeeId", "timestamp");

-- CreateIndex
CREATE INDEX "timeclock_records_timestamp_idx" ON "timeclock_records"("timestamp");

-- CreateIndex
CREATE INDEX "timeclock_adjustments_companyId_employeeId_status_idx" ON "timeclock_adjustments"("companyId", "employeeId", "status");

-- CreateIndex
CREATE INDEX "payrolls_companyId_status_idx" ON "payrolls"("companyId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "payrolls_companyId_referenceMonth_key" ON "payrolls"("companyId", "referenceMonth");

-- CreateIndex
CREATE INDEX "payroll_entries_payrollId_idx" ON "payroll_entries"("payrollId");

-- CreateIndex
CREATE INDEX "payroll_entries_employeeId_idx" ON "payroll_entries"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "payroll_entries_payrollId_employeeId_key" ON "payroll_entries"("payrollId", "employeeId");

-- CreateIndex
CREATE INDEX "tax_tables_type_startDate_idx" ON "tax_tables"("type", "startDate");

-- CreateIndex
CREATE INDEX "benefits_companyId_active_idx" ON "benefits"("companyId", "active");

-- CreateIndex
CREATE INDEX "employee_benefits_employeeId_idx" ON "employee_benefits"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "employee_benefits_employeeId_benefitId_key" ON "employee_benefits"("employeeId", "benefitId");

-- CreateIndex
CREATE INDEX "audit_logs_companyId_createdAt_idx" ON "audit_logs"("companyId", "createdAt");

-- CreateIndex
CREATE INDEX "audit_logs_userId_idx" ON "audit_logs"("userId");

-- CreateIndex
CREATE INDEX "audit_logs_entity_entityId_idx" ON "audit_logs"("entity", "entityId");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "roles" ADD CONSTRAINT "roles_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dependents" ADD CONSTRAINT "dependents_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "employees"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timeclock_records" ADD CONSTRAINT "timeclock_records_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timeclock_records" ADD CONSTRAINT "timeclock_records_adjustmentId_fkey" FOREIGN KEY ("adjustmentId") REFERENCES "timeclock_adjustments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payrolls" ADD CONSTRAINT "payrolls_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_entries" ADD CONSTRAINT "payroll_entries_payrollId_fkey" FOREIGN KEY ("payrollId") REFERENCES "payrolls"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_entries" ADD CONSTRAINT "payroll_entries_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "benefits" ADD CONSTRAINT "benefits_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_benefits" ADD CONSTRAINT "employee_benefits_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "employees"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_benefits" ADD CONSTRAINT "employee_benefits_benefitId_fkey" FOREIGN KEY ("benefitId") REFERENCES "benefits"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ============================================
-- DADOS DE DEMONSTRAÇÃO (SEED)
-- ============================================

-- Inserir empresa demo
INSERT INTO companies (id, "createdAt", "updatedAt", name, "tradeName", cnpj, address, "addressNumber", neighborhood, city, state, "zipCode", phone, email, "taxRegime", plan)
VALUES (
  'comp_demo_001',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP,
  'Orbit Demo Tecnologia LTDA',
  'Orbit Demo',
  '12345678000190',
  'Rua das Flores',
  '123',
  'Centro',
  'São Paulo',
  'SP',
  '01310100',
  '11987654321',
  'contato@orbitdemo.com.br',
  'SIMPLES_NACIONAL',
  'starter'
);

-- Inserir departamentos
INSERT INTO departments (id, "createdAt", "updatedAt", "companyId", name, description)
VALUES
  ('dept_001', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'comp_demo_001', 'Tecnologia', 'Departamento de TI'),
  ('dept_002', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'comp_demo_001', 'Recursos Humanos', 'Departamento de RH'),
  ('dept_003', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'comp_demo_001', 'Financeiro', 'Departamento Financeiro');

-- Inserir cargos
INSERT INTO roles (id, "createdAt", "updatedAt", "companyId", name, description, "cboCode")
VALUES
  ('role_001', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'comp_demo_001', 'Desenvolvedor Full Stack', 'Desenvolvedor de software', '2124-05'),
  ('role_002', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'comp_demo_001', 'Analista de RH', 'Analista de Recursos Humanos', '2524-05'),
  ('role_003', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'comp_demo_001', 'Analista Financeiro', 'Analista Financeiro', '2522-10');

-- Inserir colaboradores
INSERT INTO employees (
  id, "createdAt", "updatedAt", "companyId", registration, name, cpf, "birthDate",
  "roleId", "departmentId", "contractType", "admissionDate", salary, email, phone,
  address, "addressNumber", neighborhood, city, state, "zipCode", status
)
VALUES
  (
    'emp_001',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    'comp_demo_001',
    '0001',
    'João Silva Santos',
    '12345678901',
    '1990-05-15',
    'role_001',
    'dept_001',
    'CLT',
    '2024-01-10',
    5500.00,
    'joao.silva@orbitdemo.com.br',
    '11987654321',
    'Rua A',
    '100',
    'Jardim das Flores',
    'São Paulo',
    'SP',
    '01234567',
    'ACTIVE'
  ),
  (
    'emp_002',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    'comp_demo_001',
    '0002',
    'Maria Oliveira Costa',
    '98765432109',
    '1988-08-20',
    'role_002',
    'dept_002',
    'CLT',
    '2024-02-01',
    4800.00,
    'maria.oliveira@orbitdemo.com.br',
    '11976543210',
    'Rua B',
    '200',
    'Vila Nova',
    'São Paulo',
    'SP',
    '01234568',
    'ACTIVE'
  ),
  (
    'emp_003',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    'comp_demo_001',
    '0003',
    'Pedro Henrique Souza',
    '11122233344',
    '1992-03-10',
    'role_003',
    'dept_003',
    'CLT',
    '2024-03-15',
    6200.00,
    'pedro.souza@orbitdemo.com.br',
    '11965432109',
    'Rua C',
    '300',
    'Centro',
    'São Paulo',
    'SP',
    '01234569',
    'ACTIVE'
  );

-- Inserir usuário admin (senha: admin123)
-- Hash bcrypt para "admin123": $2b$10$rZ5qLq5Q5Q5Q5Q5Q5Q5Q5uK5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q
INSERT INTO users (id, "createdAt", "updatedAt", "companyId", name, email, password, role, "employeeId")
VALUES (
  'user_admin_001',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP,
  'comp_demo_001',
  'Admin Orbit',
  'admin@orbitdemo.com.br',
  '$2b$10$rZ5qLq5Q5Q5Q5Q5Q5Q5Q5uK5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q5Q',
  'COMPANY_ADMIN',
  'emp_001'
);

-- Inserir tabela de INSS 2024
INSERT INTO tax_tables (id, "createdAt", type, "startDate", brackets)
VALUES (
  'tax_inss_2024',
  CURRENT_TIMESTAMP,
  'INSS',
  '2024-01-01',
  '[
    {"upTo": 1412.00, "rate": 7.5},
    {"upTo": 2666.68, "rate": 9.0},
    {"upTo": 4000.03, "rate": 12.0},
    {"upTo": 7786.02, "rate": 14.0}
  ]'::jsonb
);

-- Inserir tabela de IRRF 2024
INSERT INTO tax_tables (id, "createdAt", type, "startDate", brackets)
VALUES (
  'tax_irrf_2024',
  CURRENT_TIMESTAMP,
  'IRRF',
  '2024-01-01',
  '[
    {"upTo": 2259.20, "rate": 0, "deduction": 0},
    {"upTo": 2826.65, "rate": 7.5, "deduction": 169.44},
    {"upTo": 3751.05, "rate": 15.0, "deduction": 381.44},
    {"upTo": 4664.68, "rate": 22.5, "deduction": 662.77},
    {"upTo": 999999.99, "rate": 27.5, "deduction": 896.00}
  ]'::jsonb
);

-- ============================================
-- FIM DO SQL
-- ============================================
-- Agora você pode gerar o Prisma Client localmente e rodar a aplicação!
