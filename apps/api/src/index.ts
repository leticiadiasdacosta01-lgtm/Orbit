import 'dotenv/config'
import { buildApp } from './app'
import { env } from './config/env'

async function start() {
  const app = await buildApp()

  try {
    await app.listen({
      port: env.PORT,
      host: env.HOST,
    })

    console.info(`
🚀 Orbit API is running!

📍 URL: http://${env.HOST}:${env.PORT}
🌍 Environment: ${env.NODE_ENV}
📊 Database: Connected
🔴 Redis: Connected
    `)
  } catch (err) {
    app.log.error(err)
    process.exit(1)
  }
}

start()
