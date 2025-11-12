import { prisma } from '@orbit/database'

class EmployeeService {
  async list(companyId: string) {
    const employees = await prisma.employee.findMany({
      where: {
        companyId,
        deletedAt: null,
      },
      select: {
        id: true,
        registration: true,
        name: true,
        email: true,
        status: true,
        role: {
          select: {
            id: true,
            name: true,
          },
        },
        department: {
          select: {
            id: true,
            name: true,
          },
        },
        salary: true,
        admissionDate: true,
      },
      orderBy: {
        name: 'asc',
      },
    })

    return employees
  }

  async getById(id: string, companyId: string) {
    const employee = await prisma.employee.findFirst({
      where: {
        id,
        companyId,
        deletedAt: null,
      },
      include: {
        role: true,
        department: true,
        dependentsList: true,
        employeeBenefits: {
          include: {
            benefit: true,
          },
        },
      },
    })

    return employee
  }
}

export const employeeService = new EmployeeService()
