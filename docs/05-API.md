# API Documentation - Orbit ERP

## 🌐 Base URL

```
Development: http://localhost:3001/api/v1
Production:  https://api.orbit.app/api/v1
```

---

## 🔐 Autenticação

### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@company.com",
  "password": "********"
}

Response 200:
{
  "success": true,
  "data": {
    "user": {
      "id": "clx...",
      "name": "João Silva",
      "email": "user@company.com",
      "role": "HR_MANAGER",
      "companyId": "clx..."
    },
    "token": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

### Headers Requeridos
```http
Authorization: Bearer <token>
X-Company-Id: <companyId>
```

---

## 👥 Colaboradores

### Listar Colaboradores
```http
GET /employees?page=1&limit=20&status=ACTIVE&department=clx...

Response 200:
{
  "success": true,
  "data": [
    {
      "id": "clx...",
      "name": "Maria Santos",
      "registration": "00123",
      "email": "maria@company.com",
      "role": { "id": "...", "name": "Analista" },
      "department": { "id": "...", "name": "TI" },
      "salary": 5000.00,
      "status": "ACTIVE",
      "admissionDate": "2024-01-15T00:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "pages": 3
  }
}
```

### Criar Colaborador
```http
POST /employees
Content-Type: application/json

{
  "name": "Pedro Oliveira",
  "cpf": "12345678900",
  "email": "pedro@company.com",
  "birthDate": "1995-03-20",
  "roleId": "clx...",
  "departmentId": "clx...",
  "contractType": "CLT",
  "admissionDate": "2025-01-15",
  "salary": 4500.00,
  "dependents": 1
}

Response 201:
{
  "success": true,
  "data": {
    "id": "clx...",
    "registration": "00124",
    ...
  }
}
```

### Buscar Colaborador
```http
GET /employees/:id

Response 200:
{
  "success": true,
  "data": {
    "id": "clx...",
    "name": "Maria Santos",
    "cpf": "***.***.678-**",
    "email": "maria@company.com",
    "phone": "(11) 98765-4321",
    "role": { ... },
    "department": { ... },
    "manager": { "id": "...", "name": "Carlos Silva" },
    "salary": 5000.00,
    "benefits": [
      { "type": "HEALTH_PLAN", "name": "Unimed" },
      { "type": "MEAL_VOUCHER", "value": 30.00 }
    ],
    "documents": [
      { "type": "RG", "url": "..." },
      { "type": "CPF", "url": "..." }
    ]
  }
}
```

### Atualizar Colaborador
```http
PATCH /employees/:id

{
  "salary": 5500.00,
  "roleId": "clx..."
}

Response 200:
{
  "success": true,
  "data": { ... }
}
```

### Desligar Colaborador
```http
POST /employees/:id/terminate

{
  "terminationDate": "2025-02-28",
  "reason": "RESIGNATION"
}

Response 200:
{
  "success": true,
  "data": {
    "id": "clx...",
    "status": "TERMINATED",
    "terminationDate": "2025-02-28"
  }
}
```

---

## ⏰ Ponto Eletrônico

### Registrar Ponto
```http
POST /timeclock/register

{
  "type": "ENTRY",
  "timestamp": "2025-01-15T08:05:00Z",
  "location": {
    "lat": -23.5505,
    "lng": -46.6333,
    "accuracy": 10
  }
}

Response 201:
{
  "success": true,
  "data": {
    "id": "clx...",
    "timestamp": "2025-01-15T08:05:00Z",
    "type": "ENTRY",
    "source": "WEB",
    "summary": {
      "expectedTime": "08:00",
      "difference": "+5 min",
      "withinTolerance": true
    }
  }
}
```

### Espelho de Ponto
```http
GET /timeclock/timesheet?month=2025-01

Response 200:
{
  "success": true,
  "data": {
    "month": "2025-01",
    "employee": { "id": "...", "name": "Maria Santos" },
    "workDays": 22,
    "workedDays": 20,
    "absences": 2,
    "totalHours": "176:00",
    "overtime": "8:30",
    "bankBalance": "+2:30",
    "records": [
      {
        "date": "2025-01-02",
        "entries": [
          { "time": "08:00", "type": "ENTRY" },
          { "time": "12:00", "type": "LUNCH_OUT" },
          { "time": "13:00", "type": "LUNCH_IN" },
          { "time": "18:05", "type": "EXIT" }
        ],
        "totalHours": "9:05",
        "overtime": "1:05",
        "status": "COMPLETE"
      }
    ]
  }
}
```

### Solicitar Ajuste de Ponto
```http
POST /timeclock/adjustments

{
  "date": "2025-01-15",
  "type": "ENTRY",
  "requestedTime": "08:00:00",
  "justification": "Esqueci de bater o ponto",
  "attachment": "base64..."
}

Response 201:
{
  "success": true,
  "data": {
    "id": "clx...",
    "status": "PENDING",
    "message": "Solicitação enviada para aprovação"
  }
}
```

### Aprovar/Rejeitar Ajuste
```http
POST /timeclock/adjustments/:id/review

{
  "action": "APPROVE",
  "comment": "Justificativa aceita"
}

Response 200:
{
  "success": true,
  "data": {
    "id": "clx...",
    "status": "APPROVED",
    "recordCreated": true
  }
}
```

---

## 💰 Folha de Pagamento

### Iniciar Cálculo de Folha
```http
POST /payroll/2025-01/calculate

Response 202:
{
  "success": true,
  "data": {
    "payrollId": "clx...",
    "status": "CALCULATING",
    "message": "Cálculo iniciado"
  }
}
```

### Status do Cálculo
```http
GET /payroll/2025-01/status

Response 200:
{
  "success": true,
  "data": {
    "status": "CALCULATED",
    "totalEmployees": 45,
    "processed": 45,
    "errors": 0,
    "totals": {
      "gross": 225000.00,
      "net": 180000.00,
      "inss": 18000.00,
      "irrf": 12000.00,
      "fgts": 18000.00
    }
  }
}
```

### Ver Folha Calculada
```http
GET /payroll/2025-01

Response 200:
{
  "success": true,
  "data": {
    "id": "clx...",
    "referenceMonth": "2025-01-01",
    "status": "CALCULATED",
    "totals": { ... },
    "entries": [
      {
        "employee": { "id": "...", "name": "Maria Santos", "registration": "00123" },
        "earnings": {
          "baseSalary": 5000.00,
          "overtime50": 150.00,
          "bonus": 200.00,
          "total": 5350.00
        },
        "deductions": {
          "inss": 535.00,
          "irrf": 150.00,
          "transportVoucher": 180.00,
          "total": 865.00
        },
        "net": 4485.00,
        "employerCosts": {
          "fgts": 428.00,
          "employerInss": 1070.00,
          "total": 1498.00
        }
      }
    ]
  }
}
```

### Fechar Folha
```http
POST /payroll/2025-01/close

Response 200:
{
  "success": true,
  "data": {
    "status": "APPROVED",
    "closedAt": "2025-02-05T10:30:00Z",
    "payslipsGenerated": 45
  }
}
```

### Enviar Holerites
```http
POST /payroll/2025-01/send-payslips

Response 202:
{
  "success": true,
  "data": {
    "jobId": "job_123",
    "message": "Envio de holerites iniciado"
  }
}
```

### Holerite Individual
```http
GET /payroll/2025-01/employees/:employeeId/payslip

Response 200:
{
  "success": true,
  "data": {
    "pdfUrl": "https://s3.../payslip.pdf",
    "employee": { ... },
    "details": { ... }
  }
}
```

---

## 🎁 Benefícios

### Listar Benefícios
```http
GET /benefits

Response 200:
{
  "success": true,
  "data": [
    {
      "id": "clx...",
      "type": "HEALTH_PLAN",
      "name": "Plano Unimed Básico",
      "fixedValue": 350.00,
      "employeeDiscountPercentage": 30,
      "active": true,
      "enrolledEmployees": 32
    }
  ]
}
```

### Benefícios do Colaborador
```http
GET /employees/:id/benefits

Response 200:
{
  "success": true,
  "data": [
    {
      "benefit": { "type": "HEALTH_PLAN", "name": "Unimed Básico" },
      "value": 350.00,
      "discount": 105.00,
      "includeDependents": true,
      "dependentsCount": 2,
      "startDate": "2024-01-01"
    }
  ]
}
```

---

## 📊 Avaliação de Desempenho

### Listar Ciclos
```http
GET /performance/cycles

Response 200:
{
  "success": true,
  "data": [
    {
      "id": "clx...",
      "name": "Avaliação 1º Semestre 2025",
      "type": "DEGREE_360",
      "startDate": "2025-06-01",
      "endDate": "2025-06-30",
      "status": "IN_PROGRESS",
      "totalEvaluations": 45,
      "completed": 12
    }
  ]
}
```

### Minhas Avaliações Pendentes
```http
GET /performance/evaluations/pending

Response 200:
{
  "success": true,
  "data": [
    {
      "id": "clx...",
      "cycle": { "name": "Avaliação 1º Semestre" },
      "employee": { "name": "Pedro Oliveira" },
      "type": "MANAGER",
      "dueDate": "2025-06-30"
    }
  ]
}
```

### Submeter Avaliação
```http
POST /performance/evaluations/:id/submit

{
  "answers": [
    {
      "competencyId": "comp_1",
      "score": 4,
      "comment": "Excelente capacidade técnica"
    },
    {
      "competencyId": "comp_2",
      "score": 3,
      "comment": "Bom trabalho em equipe"
    }
  ],
  "developmentPlan": "Participar de curso de liderança"
}

Response 200:
{
  "success": true,
  "data": {
    "status": "COMPLETED",
    "finalScore": 3.75
  }
}
```

---

## 📱 Feed Social

### Listar Posts
```http
GET /feed?page=1&limit=10

Response 200:
{
  "success": true,
  "data": [
    {
      "id": "clx...",
      "type": "ANNOUNCEMENT",
      "author": { "name": "RH", "avatar": "..." },
      "content": "Bem-vindo ao novo colaborador Pedro!",
      "images": ["url1", "url2"],
      "pinned": true,
      "likesCount": 23,
      "commentsCount": 5,
      "liked": false,
      "publishedAt": "2025-01-15T10:00:00Z"
    }
  ]
}
```

### Criar Post
```http
POST /feed/posts

{
  "type": "GENERAL",
  "content": "Parabéns ao time de vendas pela meta!",
  "images": ["base64..."],
  "visibility": { "all": true }
}

Response 201:
{
  "success": true,
  "data": { ... }
}
```

### Curtir Post
```http
POST /feed/posts/:id/like

Response 200:
{
  "success": true,
  "data": {
    "liked": true,
    "likesCount": 24
  }
}
```

### Comentar
```http
POST /feed/posts/:id/comments

{
  "content": "Parabéns, pessoal! 🎉"
}

Response 201:
{
  "success": true,
  "data": {
    "id": "clx...",
    "content": "Parabéns, pessoal! 🎉",
    "author": { ... },
    "createdAt": "2025-01-15T10:30:00Z"
  }
}
```

---

## 📈 Relatórios

### Dashboard Executivo
```http
GET /reports/dashboard

Response 200:
{
  "success": true,
  "data": {
    "headcount": {
      "total": 45,
      "active": 43,
      "onLeave": 2,
      "growthRate": "+5.2%"
    },
    "payrollCosts": {
      "currentMonth": 180000.00,
      "lastMonth": 175000.00,
      "variance": "+2.9%",
      "avgCostPerEmployee": 4000.00
    },
    "turnover": {
      "rate": "2.1%",
      "admissions": 3,
      "terminations": 1
    },
    "absenteeism": {
      "rate": "1.5%",
      "totalDays": 8
    }
  }
}
```

### Exportar Relatório
```http
POST /reports/export

{
  "type": "PAYROLL_SUMMARY",
  "month": "2025-01",
  "format": "XLSX"
}

Response 202:
{
  "success": true,
  "data": {
    "jobId": "job_456",
    "message": "Relatório sendo gerado"
  }
}

# Polling
GET /reports/export/job_456

Response 200:
{
  "success": true,
  "data": {
    "status": "COMPLETED",
    "downloadUrl": "https://s3.../report.xlsx",
    "expiresAt": "2025-01-16T10:00:00Z"
  }
}
```

---

## ⚙️ Configurações

### Tabelas Tributárias
```http
GET /settings/tax-tables?type=INSS&date=2025-01-01

Response 200:
{
  "success": true,
  "data": {
    "type": "INSS",
    "startDate": "2024-01-01",
    "endDate": null,
    "brackets": [
      { "upTo": 1412.00, "rate": 7.5, "deduction": 0 },
      { "upTo": 2666.68, "rate": 9.0, "deduction": 21.18 },
      { "upTo": 4000.03, "rate": 12.0, "deduction": 101.18 },
      { "upTo": 7786.02, "rate": 14.0, "deduction": 181.18 }
    ]
  }
}
```

### Atualizar Tabela Tributária
```http
POST /settings/tax-tables

{
  "type": "INSS",
  "startDate": "2025-01-01",
  "brackets": [ ... ]
}

Response 201:
{
  "success": true,
  "data": { ... }
}
```

---

## 🚨 Tratamento de Erros

### Formato de Erro
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Dados inválidos",
    "details": [
      {
        "field": "cpf",
        "message": "CPF inválido"
      },
      {
        "field": "salary",
        "message": "Salário deve ser maior que 0"
      }
    ]
  }
}
```

### Códigos de Erro
```
400 - Bad Request
  VALIDATION_ERROR: Validação falhou
  INVALID_CPF: CPF inválido
  DUPLICATE_ENTRY: Registro duplicado

401 - Unauthorized
  INVALID_CREDENTIALS: Email/senha incorretos
  TOKEN_EXPIRED: Token expirado
  MISSING_TOKEN: Token não fornecido

403 - Forbidden
  INSUFFICIENT_PERMISSIONS: Sem permissão
  TENANT_MISMATCH: Empresa incorreta

404 - Not Found
  RESOURCE_NOT_FOUND: Recurso não encontrado

409 - Conflict
  PAYROLL_ALREADY_CLOSED: Folha já fechada
  EMPLOYEE_HAS_DEPENDENCIES: Colaborador tem dependências

422 - Unprocessable Entity
  BUSINESS_RULE_VIOLATION: Regra de negócio violada

429 - Too Many Requests
  RATE_LIMIT_EXCEEDED: Limite de requisições excedido

500 - Internal Server Error
  INTERNAL_ERROR: Erro interno do servidor
  DATABASE_ERROR: Erro no banco de dados
```

---

## 📊 Rate Limiting

```
- 1000 requisições/hora por token
- 100 requisições/minuto por IP

Headers de resposta:
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 950
X-RateLimit-Reset: 1642521600
```

---

## 🔄 Webhooks (Futuro)

```http
POST https://your-app.com/webhook

{
  "event": "payroll.closed",
  "data": {
    "payrollId": "clx...",
    "month": "2025-01"
  },
  "timestamp": "2025-01-15T10:00:00Z"
}
```

**Eventos disponíveis**:
- `employee.created`
- `employee.terminated`
- `payroll.calculated`
- `payroll.closed`
- `timeclock.adjustment.approved`

---

**Próximo**: [06-ROADMAP.md](./06-ROADMAP.md) - Roadmap de Desenvolvimento
