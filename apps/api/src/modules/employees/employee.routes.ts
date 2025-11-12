import { FastifyInstance } from 'fastify'
import { employeeService } from './employee.service'

export async function employeeRoutes(app: FastifyInstance) {
  // List employees
  app.get('/', {
    onRequest: [app.authenticate],
    handler: async (request, reply) => {
      const tenantId = request.tenantId!

      const employees = await employeeService.list(tenantId)

      return reply.send({
        success: true,
        data: employees,
      })
    },
  })

  // Get employee by ID
  app.get<{ Params: { id: string } }>('/:id', {
    onRequest: [app.authenticate],
    handler: async (request, reply) => {
      const { id } = request.params
      const tenantId = request.tenantId!

      const employee = await employeeService.getById(id, tenantId)

      if (!employee) {
        return reply.status(404).send({
          success: false,
          error: {
            code: 'EMPLOYEE_NOT_FOUND',
            message: 'Employee not found',
          },
        })
      }

      return reply.send({
        success: true,
        data: employee,
      })
    },
  })
}
