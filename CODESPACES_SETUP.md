# 🚀 Configuração para GitHub Codespaces

## ⚠️ PROBLEMA IDENTIFICADO

Você está rodando no **GitHub Codespaces**, não em localhost! As URLs são completamente diferentes:

- ❌ Localhost: `http://localhost:3000`
- ✅ Codespaces: `https://[seu-codespace]-3000.app.github.dev`

## 📝 O QUE FOI AJUSTADO

Atualizei o arquivo `.env` com as URLs do Codespaces baseado na URL que você forneceu:
- Frontend: `https://jubilant-journey-97g59vg6wvggh7qj7-3000.app.github.dev`
- Backend: `https://jubilant-journey-97g59vg6wvggh7qj7-3001.app.github.dev`

## ⚡ COMO DESCOBRIR SUA URL DO CODESPACES

1. **Vá até a aba "PORTS"** no painel inferior do VS Code
2. **Procure pela porta 3000** (Frontend)
3. **Copie a URL completa** que aparece
4. Exemplo: `https://jubilant-journey-97g59vg6wvggh7qj7-3000.app.github.dev`

## 🔧 SE A URL DO CODESPACE MUDAR

Toda vez que o Codespace for reiniciado ou recriado, a URL pode mudar. Nesse caso:

### Opção 1: Atualizar manualmente o .env

Edite o arquivo `.env` e atualize estas linhas com sua nova URL:

```env
# Mude APENAS o nome do codespace (a parte antes do -3000 ou -3001)
API_URL="https://[SEU-CODESPACE]-3001.app.github.dev"
NEXT_PUBLIC_API_URL="https://[SEU-CODESPACE]-3001.app.github.dev"
CORS_ORIGIN="https://[SEU-CODESPACE]-3000.app.github.dev"
NEXTAUTH_URL="https://[SEU-CODESPACE]-3000.app.github.dev"
```

### Opção 2: Script automático (RECOMENDADO)

Execute este comando para detectar e atualizar automaticamente:

```bash
# Copie a URL completa da porta 3000 do painel PORTS
export CODESPACE_URL="https://sua-url-completa-3000.app.github.dev"

# Execute o script para atualizar o .env
node scripts/update-codespace-env.js
```

## 📋 PRÓXIMOS PASSOS

1. **Execute o SQL no Supabase** (se ainda não fez):
   - Acesse: https://supabase.com/dashboard/project/darrtoexfebfbmzyubxf/sql/new
   - Cole TODO o conteúdo de `SUPABASE_SQL_COMPLETO.sql`
   - Clique em **RUN**

2. **Rode a aplicação**:
   ```bash
   pnpm dev
   ```

3. **Acesse a aplicação**:
   - Vá até a aba **PORTS** no VS Code
   - Clique na porta **3000** para abrir no navegador
   - Ou acesse: `https://jubilant-journey-97g59vg6wvggh7qj7-3000.app.github.dev`

4. **Faça login**:
   - Email: `admin@orbitdemo.com.br`
   - Senha: `admin123`

## 🐛 TROUBLESHOOTING

### Erro: CORS / ERR_CONNECTION_REFUSED
- Verifique se as URLs no `.env` correspondem às URLs do painel PORTS
- Reinicie o servidor (`pnpm dev`)

### Erro: Failed to load resource: net::ERR_CONNECTION_REFUSED
- O backend não está rodando na porta 3001
- Execute `pnpm dev` que roda frontend E backend juntos

### Erro: Database connection failed
- Certifique-se que executou o SQL no Supabase
- Verifique se a senha no `.env` está correta: `Le28042022`

### Portas não aparecem no painel
- Vá em: **Terminal → Ports** no VS Code
- Ou pressione `Ctrl+Shift+P` e digite "Ports"
