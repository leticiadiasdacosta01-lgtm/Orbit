# @orbit/database

Database package for Orbit ERP using Prisma ORM with PostgreSQL.

## 📦 What's included

- **Prisma Schema**: Complete database schema with all models
- **Migrations**: Database migrations
- **Seed**: Initial data seeding
- **Prisma Client**: Type-safe database client

## 🚀 Commands

```bash
# Generate Prisma Client
pnpm db:generate

# Create a new migration
pnpm db:migrate

# Deploy migrations (production)
pnpm db:migrate:deploy

# Push schema without migration (dev only)
pnpm db:push

# Seed database
pnpm db:seed

# Open Prisma Studio (GUI)
pnpm db:studio

# Reset database (WARNING: deletes all data)
pnpm db:reset
```

## 📊 Schema Overview

### Core Models
- `Company`: Multi-tenant company data
- `User`: System users with authentication
- `Session`: User sessions

### HR Models
- `Employee`: Employee data
- `Department`: Organizational structure
- `Role`: Job roles
- `Dependent`: Employee dependents

### Timeclock
- `TimeclockRecord`: Punch clock records
- `TimeclockAdjustment`: Time adjustments

### Payroll
- `Payroll`: Monthly payroll
- `PayrollEntry`: Individual payroll entries
- `TaxTable`: Tax calculation tables (INSS, IRRF, FGTS)

### Benefits
- `Benefit`: Company benefits
- `EmployeeBenefit`: Employee benefit assignments

### Audit
- `AuditLog`: Audit trail for all actions

## 🔧 Usage

```typescript
import { prisma } from '@orbit/database'

// Example: Find all active employees
const employees = await prisma.employee.findMany({
  where: {
    companyId: 'your-company-id',
    status: 'ACTIVE'
  },
  include: {
    role: true,
    department: true
  }
})
```

## 🌱 Seed Data

After running `pnpm db:seed`, you get:

- 1 demo company (Tech Solutions Ltda)
- 1 admin user (admin@techsol.com.br / orbit123)
- 3 departments (Tech, HR, Sales)
- 3 roles
- 3 employees
- 3 benefits (VT, VR, Health Plan)
- Tax tables for 2025 (INSS, IRRF, FGTS)

## 🔒 Multi-tenancy

All queries are automatically filtered by `companyId` using Prisma middleware for data isolation.

## 📚 Documentation

See the full [database documentation](../../docs/04-DATABASE.md) for detailed schema information.
