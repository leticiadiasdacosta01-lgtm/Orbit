import { PrismaClient, TaxType } from '@prisma/client'
import * as bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Starting database seed...')

  // Limpar dados existentes (apenas em dev)
  if (process.env.NODE_ENV === 'development') {
    console.log('🧹 Cleaning existing data...')
    await prisma.auditLog.deleteMany()
    await prisma.employeeBenefit.deleteMany()
    await prisma.benefit.deleteMany()
    await prisma.payrollEntry.deleteMany()
    await prisma.payroll.deleteMany()
    await prisma.timeclockAdjustment.deleteMany()
    await prisma.timeclockRecord.deleteMany()
    await prisma.dependent.deleteMany()
    await prisma.employee.deleteMany()
    await prisma.role.deleteMany()
    await prisma.department.deleteMany()
    await prisma.session.deleteMany()
    await prisma.user.deleteMany()
    await prisma.company.deleteMany()
    await prisma.taxTable.deleteMany()
  }

  // 1. Criar Tabelas Tributárias 2025
  console.log('📊 Creating tax tables...')

  // Tabela INSS 2025
  await prisma.taxTable.create({
    data: {
      type: TaxType.INSS,
      startDate: new Date('2025-01-01'),
      brackets: [
        { upTo: 1412.0, rate: 7.5, deduction: 0 },
        { upTo: 2666.68, rate: 9.0, deduction: 21.18 },
        { upTo: 4000.03, rate: 12.0, deduction: 101.18 },
        { upTo: 7786.02, rate: 14.0, deduction: 181.18 },
      ],
    },
  })

  // Tabela IRRF 2025
  await prisma.taxTable.create({
    data: {
      type: TaxType.IRRF,
      startDate: new Date('2025-01-01'),
      brackets: [
        { upTo: 2259.2, rate: 0, deduction: 0 },
        { upTo: 2826.65, rate: 7.5, deduction: 169.44 },
        { upTo: 3751.05, rate: 15.0, deduction: 381.44 },
        { upTo: 4664.68, rate: 22.5, deduction: 662.77 },
        { upTo: Infinity, rate: 27.5, deduction: 896.0 },
      ],
    },
  })

  // Tabela FGTS (sempre 8%)
  await prisma.taxTable.create({
    data: {
      type: TaxType.FGTS,
      startDate: new Date('2025-01-01'),
      brackets: [{ upTo: Infinity, rate: 8.0, deduction: 0 }],
    },
  })

  // 2. Criar Empresa Demo
  console.log('🏢 Creating demo company...')

  const hashedPassword = await bcrypt.hash('orbit123', 10)

  const company = await prisma.company.create({
    data: {
      name: 'Tech Solutions Ltda',
      tradeName: 'TechSol',
      cnpj: '12345678000199',
      address: 'Rua das Flores',
      addressNumber: '123',
      neighborhood: 'Centro',
      city: 'São Paulo',
      state: 'SP',
      zipCode: '01234567',
      phone: '(11) 3456-7890',
      email: 'contato@techsol.com.br',
      taxRegime: 'SIMPLES_NACIONAL',
      active: true,
      plan: 'growth',
    },
  })

  console.log(`✅ Company created: ${company.name}`)

  // 3. Criar Usuário Admin
  console.log('👤 Creating admin user...')

  const adminUser = await prisma.user.create({
    data: {
      companyId: company.id,
      name: 'Admin TechSol',
      email: 'admin@techsol.com.br',
      password: hashedPassword,
      role: 'COMPANY_ADMIN',
      active: true,
      emailVerified: new Date(),
    },
  })

  console.log(`✅ Admin user created: ${adminUser.email}`)

  // 4. Criar Departamentos
  console.log('🏗️ Creating departments...')

  const departments = await Promise.all([
    prisma.department.create({
      data: {
        companyId: company.id,
        name: 'Tecnologia',
        description: 'Desenvolvimento e infraestrutura',
        active: true,
      },
    }),
    prisma.department.create({
      data: {
        companyId: company.id,
        name: 'Recursos Humanos',
        description: 'Gestão de pessoas',
        active: true,
      },
    }),
    prisma.department.create({
      data: {
        companyId: company.id,
        name: 'Comercial',
        description: 'Vendas e atendimento',
        active: true,
      },
    }),
  ])

  console.log(`✅ Created ${departments.length} departments`)

  // 5. Criar Cargos
  console.log('💼 Creating roles...')

  const roles = await Promise.all([
    prisma.role.create({
      data: {
        companyId: company.id,
        name: 'Desenvolvedor Full Stack',
        cboCode: '2124-05',
        active: true,
      },
    }),
    prisma.role.create({
      data: {
        companyId: company.id,
        name: 'Analista de RH',
        cboCode: '2524-05',
        active: true,
      },
    }),
    prisma.role.create({
      data: {
        companyId: company.id,
        name: 'Vendedor',
        cboCode: '3541-05',
        active: true,
      },
    }),
  ])

  console.log(`✅ Created ${roles.length} roles`)

  // 6. Criar Colaboradores Demo
  console.log('👥 Creating demo employees...')

  const employees = await Promise.all([
    prisma.employee.create({
      data: {
        companyId: company.id,
        registration: '00001',
        name: 'João Silva',
        cpf: '12345678901',
        birthDate: new Date('1990-05-15'),
        email: 'joao.silva@techsol.com.br',
        phone: '(11) 98765-4321',
        roleId: roles[0].id,
        departmentId: departments[0].id,
        contractType: 'CLT',
        admissionDate: new Date('2023-01-15'),
        salary: 6000.0,
        status: 'ACTIVE',
      },
    }),
    prisma.employee.create({
      data: {
        companyId: company.id,
        registration: '00002',
        name: 'Maria Santos',
        cpf: '98765432109',
        birthDate: new Date('1995-08-20'),
        email: 'maria.santos@techsol.com.br',
        phone: '(11) 98765-1234',
        roleId: roles[1].id,
        departmentId: departments[1].id,
        contractType: 'CLT',
        admissionDate: new Date('2023-03-01'),
        salary: 4500.0,
        dependents: 1,
        status: 'ACTIVE',
      },
    }),
    prisma.employee.create({
      data: {
        companyId: company.id,
        registration: '00003',
        name: 'Pedro Oliveira',
        cpf: '45678912301',
        birthDate: new Date('1988-11-10'),
        email: 'pedro.oliveira@techsol.com.br',
        phone: '(11) 98765-5678',
        roleId: roles[2].id,
        departmentId: departments[2].id,
        contractType: 'CLT',
        admissionDate: new Date('2023-06-01'),
        salary: 3500.0,
        status: 'ACTIVE',
      },
    }),
  ])

  console.log(`✅ Created ${employees.length} employees`)

  // 7. Criar Benefícios
  console.log('🎁 Creating benefits...')

  const benefits = await Promise.all([
    prisma.benefit.create({
      data: {
        companyId: company.id,
        type: 'TRANSPORT_VOUCHER',
        name: 'Vale Transporte',
        fixedValue: 15.0, // R$ 15/dia
        employeeDiscountPercentage: 6.0,
        active: true,
      },
    }),
    prisma.benefit.create({
      data: {
        companyId: company.id,
        type: 'MEAL_VOUCHER',
        name: 'Vale Refeição',
        fixedValue: 30.0, // R$ 30/dia
        active: true,
      },
    }),
    prisma.benefit.create({
      data: {
        companyId: company.id,
        type: 'HEALTH_PLAN',
        name: 'Plano de Saúde Unimed',
        fixedValue: 350.0,
        employeeDiscountPercentage: 30.0,
        active: true,
      },
    }),
  ])

  console.log(`✅ Created ${benefits.length} benefits`)

  // 8. Atribuir benefícios aos colaboradores
  console.log('🔗 Assigning benefits to employees...')

  for (const employee of employees) {
    // VT e VR para todos
    await prisma.employeeBenefit.create({
      data: {
        employeeId: employee.id,
        benefitId: benefits[0].id, // VT
        startDate: employee.admissionDate,
        active: true,
      },
    })

    await prisma.employeeBenefit.create({
      data: {
        employeeId: employee.id,
        benefitId: benefits[1].id, // VR
        startDate: employee.admissionDate,
        active: true,
      },
    })

    // Plano de saúde apenas para os dois primeiros
    if (employee.registration !== '00003') {
      await prisma.employeeBenefit.create({
        data: {
          employeeId: employee.id,
          benefitId: benefits[2].id, // Plano de Saúde
          startDate: employee.admissionDate,
          active: true,
        },
      })
    }
  }

  console.log('✅ Benefits assigned')

  console.log('\n🎉 Seed completed successfully!')
  console.log('\n📝 Login credentials:')
  console.log('   Email: admin@techsol.com.br')
  console.log('   Password: orbit123')
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
