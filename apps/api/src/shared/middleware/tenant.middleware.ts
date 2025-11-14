import { FastifyRequest, FastifyReply } from 'fastify'

declare module 'fastify' {
  interface FastifyRequest {
    tenantId?: string
  }
}

export async function tenantMiddleware(
  request: FastifyRequest,
  reply: FastifyReply
) {
  // Skip tenant check for public routes
  const publicRoutes = ['/health', '/api/v1/auth/login', '/api/v1/auth/register']
  if (publicRoutes.includes(request.url)) {
    return
  }

  // Extract tenant from JWT token
  try {
    await request.jwtVerify()
    const payload = request.user as any

    if (!payload.companyId) {
      return reply.status(403).send({
        success: false,
        error: {
          code: 'MISSING_TENANT',
          message: 'Tenant ID not found in token',
        },
      })
    }

    request.tenantId = payload.companyId
  } catch (err) {
    return reply.status(401).send({
      success: false,
      error: {
        code: 'UNAUTHORIZED',
        message: 'Invalid or missing authentication token',
      },
    })
  }
}
