import Fastify from 'fastify'
import cors from '@fastify/cors'
import helmet from '@fastify/helmet'
import sensible from '@fastify/sensible'
import rateLimit from '@fastify/rate-limit'
import jwt from '@fastify/jwt'
import redis from '@fastify/redis'
import { env } from './config/env'
import { tenantMiddleware } from './shared/middleware/tenant.middleware'
import { authRoutes } from './modules/auth/auth.routes'
import { employeeRoutes } from './modules/employees/employee.routes'

export async function buildApp() {
  const app = Fastify({
    logger: {
      level: env.NODE_ENV === 'production' ? 'info' : 'debug',
      transport:
        env.NODE_ENV === 'development'
          ? {
              target: 'pino-pretty',
              options: {
                colorize: true,
                translateTime: 'HH:MM:ss Z',
                ignore: 'pid,hostname',
              },
            }
          : undefined,
    },
  })

  // Register plugins
  await app.register(sensible)
  await app.register(helmet, {
    contentSecurityPolicy: env.NODE_ENV === 'production',
  })
  await app.register(cors, {
    origin: env.CORS_ORIGIN.split(','),
    credentials: true,
  })
  await app.register(rateLimit, {
    max: 100,
    timeWindow: '1 minute',
  })
  await app.register(jwt, {
    secret: env.JWT_SECRET,
  })
  await app.register(redis, {
    host: env.REDIS_HOST,
    port: env.REDIS_PORT,
    password: env.REDIS_PASSWORD,
  })

  // Global hooks
  app.addHook('onRequest', tenantMiddleware)

  // Health check
  app.get('/health', async () => {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    }
  })

  // API routes
  await app.register(
    async (instance) => {
      await instance.register(authRoutes, { prefix: '/auth' })
      await instance.register(employeeRoutes, { prefix: '/employees' })
      // More routes will be added here
    },
    { prefix: '/api/v1' }
  )

  // Error handler
  app.setErrorHandler((error, request, reply) => {
    app.log.error(error)

    if (error.validation) {
      return reply.status(400).send({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Validation failed',
          details: error.validation,
        },
      })
    }

    const statusCode = error.statusCode || 500
    reply.status(statusCode).send({
      success: false,
      error: {
        code: error.code || 'INTERNAL_ERROR',
        message: error.message,
      },
    })
  })

  return app
}
