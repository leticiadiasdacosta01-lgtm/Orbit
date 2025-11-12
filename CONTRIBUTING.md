# Contributing to Orbit ERP

Obrigado por considerar contribuir com o Orbit! 🎉

## 📋 Code of Conduct

Ao participar deste projeto, você concorda em manter um ambiente respeitoso e colaborativo.

## 🚀 Como Contribuir

### 1. Fork e Clone

```bash
# Fork o repositório no GitHub
# Clone seu fork
git clone https://github.com/seu-usuario/orbit.git
cd orbit

# Adicione o upstream
git remote add upstream https://github.com/orbit/orbit.git
```

### 2. Crie uma Branch

```bash
# Atualize sua main
git checkout main
git pull upstream main

# Crie uma branch para sua feature/fix
git checkout -b feature/minha-feature
# ou
git checkout -b fix/meu-bug
```

### 3. Desenvolva

- Siga o [Setup Guide](./SETUP.md)
- Escreva código limpo e bem documentado
- Adicione testes para novas features
- Mantenha os testes passando

### 4. Commit

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Exemplos de commits válidos:
git commit -m "feat: add payroll calculation service"
git commit -m "fix: correct INSS calculation for high salaries"
git commit -m "docs: update API documentation"
git commit -m "refactor: simplify employee service"
git commit -m "test: add tests for timeclock records"
git commit -m "chore: update dependencies"
```

**Tipos de commit:**
- `feat`: Nova feature
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação (não afeta funcionalidade)
- `refactor`: Refatoração de código
- `test`: Adicionar ou modificar testes
- `chore`: Tarefas de manutenção

### 5. Push e Pull Request

```bash
# Push sua branch
git push origin feature/minha-feature

# Abra um Pull Request no GitHub
```

## ✅ Checklist do PR

Antes de abrir um PR, certifique-se de:

- [ ] Código segue o style guide (ESLint + Prettier)
- [ ] Testes estão passando (`pnpm test`)
- [ ] Type checking passa (`pnpm type-check`)
- [ ] Commit messages seguem Conventional Commits
- [ ] Documentação foi atualizada (se necessário)
- [ ] PR tem título descritivo
- [ ] PR tem descrição clara do que foi feito

## 🧪 Testes

```bash
# Executar todos os testes
pnpm test

# Testes com coverage
pnpm test:coverage

# Testes E2E
pnpm test:e2e

# Testes específicos
pnpm --filter @orbit/api test
```

## 💅 Code Style

```bash
# Lint
pnpm lint

# Lint com correção automática
pnpm lint:fix

# Formatação
pnpm format

# Verificar formatação
pnpm format:check
```

## 📁 Estrutura de Branches

- `main`: Produção
- `develop`: Desenvolvimento
- `feature/*`: Novas features
- `fix/*`: Correções de bugs
- `docs/*`: Documentação
- `refactor/*`: Refatorações

## 🔍 Code Review

Todos os PRs passam por code review:

- Pelo menos 1 aprovação necessária
- CI deve estar passando
- Sem conflitos com a branch base
- Código segue padrões do projeto

## 📝 Documentação

Ao adicionar novas features:

- Atualize o README se necessário
- Adicione comentários JSDoc em funções públicas
- Atualize a documentação da API
- Adicione exemplos de uso

## 🐛 Reportando Bugs

Abra uma issue com:

- Descrição clara do bug
- Passos para reproduzir
- Comportamento esperado vs atual
- Screenshots (se aplicável)
- Versão do Node.js e sistema operacional

## 💡 Sugerindo Features

Issues de features devem conter:

- Descrição detalhada da feature
- Caso de uso (por que é útil?)
- Proposta de implementação (opcional)
- Mockups ou exemplos (se aplicável)

## 🙏 Dúvidas?

- Abra uma issue com a tag `question`
- Entre no canal de desenvolvimento no Slack
- Envie email para dev@orbit.app

---

**Obrigado por contribuir!** Toda ajuda é muito bem-vinda! 🚀
