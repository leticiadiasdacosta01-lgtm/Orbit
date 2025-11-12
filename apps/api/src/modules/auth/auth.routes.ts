import { FastifyInstance } from 'fastify'
import { authService } from './auth.service'
import { loginSchema, LoginInput } from './auth.validators'

export async function authRoutes(app: FastifyInstance) {
  // Login
  app.post<{ Body: LoginInput }>('/login', {
    schema: {
      body: loginSchema,
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: {
              type: 'object',
              properties: {
                user: { type: 'object' },
                token: { type: 'string' },
                refreshToken: { type: 'string' },
              },
            },
          },
        },
      },
    },
    handler: async (request, reply) => {
      const { email, password } = request.body

      const result = await authService.login(email, password)

      if (!result) {
        return reply.status(401).send({
          success: false,
          error: {
            code: 'INVALID_CREDENTIALS',
            message: 'Email ou senha incorretos',
          },
        })
      }

      const token = app.jwt.sign(
        {
          userId: result.user.id,
          companyId: result.user.companyId,
          role: result.user.role,
        },
        { expiresIn: '7d' }
      )

      const refreshToken = app.jwt.sign(
        { userId: result.user.id, type: 'refresh' },
        { expiresIn: '30d' }
      )

      // Save session to Redis
      await app.redis.set(
        `session:${result.user.id}`,
        JSON.stringify({ token, refreshToken }),
        'EX',
        60 * 60 * 24 * 7 // 7 days
      )

      return reply.send({
        success: true,
        data: {
          user: {
            id: result.user.id,
            name: result.user.name,
            email: result.user.email,
            role: result.user.role,
            companyId: result.user.companyId,
          },
          token,
          refreshToken,
        },
      })
    },
  })

  // Logout
  app.post('/logout', {
    onRequest: [app.authenticate],
    handler: async (request, reply) => {
      const payload = request.user as any
      await app.redis.del(`session:${payload.userId}`)

      return reply.send({
        success: true,
        message: 'Logout successful',
      })
    },
  })

  // Get current user
  app.get('/me', {
    onRequest: [app.authenticate],
    handler: async (request, reply) => {
      const payload = request.user as any
      const user = await authService.getCurrentUser(payload.userId)

      if (!user) {
        return reply.status(404).send({
          success: false,
          error: {
            code: 'USER_NOT_FOUND',
            message: 'User not found',
          },
        })
      }

      return reply.send({
        success: true,
        data: user,
      })
    },
  })
}
