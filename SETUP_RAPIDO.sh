#!/bin/bash
# Script de setup rápido para Orbit ERP no GitHub Codespaces

echo "🚀 Setup Rápido - Orbit ERP"
echo "================================"

# Criar arquivo .env no backend
echo "📝 Criando arquivo .env no backend..."
cat > apps/api/.env << 'EOF'
DATABASE_URL="postgresql://postgres:Le28042022@db.darrtoexfebfbmzyubxf.supabase.co:5432/postgres"
REDIS_HOST="localhost"
REDIS_PORT=6379
REDIS_PASSWORD=""
JWT_SECRET="orbit-jwt-secret-key-for-development-change-in-production-32-chars"
JWT_EXPIRES_IN="7d"
CORS_ORIGIN="https://jubilant-journey-97g59vg6wvggh7qj7-3000.app.github.dev"
NODE_ENV="development"
PORT=3001
HOST="0.0.0.0"
EOF

echo "✅ Arquivo .env criado em apps/api/.env"

# Instalar dependências se necessário
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependências..."
    pnpm install
fi

echo ""
echo "✅ Setup concluído!"
echo ""
echo "Para rodar a aplicação:"
echo "  pnpm dev"
echo ""
echo "Acesse pelo painel PORTS (porta 3000)"
