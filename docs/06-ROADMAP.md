# Roadmap de Desenvolvimento - Orbit ERP

## 🎯 Visão Geral

**Objetivo**: Lançar MVP funcional em 3 meses, com features essenciais para PMEs gerenciarem RH
**Metodologia**: Agile (Sprints de 2 semanas)
**Equipe**: 3-5 desenvolvedores + 1 designer + 1 product owner

---

## 📅 Timeline Geral

```
┌─────────────────────────────────────────────────────────────────────┐
│ Fase 0: Setup (2 semanas) ────────────────────────────────────────│
│ Fase 1: MVP Core (8 semanas - 4 sprints) ──────────────────────── │
│ Fase 2: Features Intermediárias (6 semanas - 3 sprints) ───────── │
│ Fase 3: Features Avançadas (6 semanas - 3 sprints) ────────────── │
│ Fase 4: Beta & Launch (4 semanas - 2 sprints) ─────────────────── │
└─────────────────────────────────────────────────────────────────────┘
Total: ~26 semanas (6 meses)
```

---

## 🚀 Fase 0: Setup Inicial
**Duração**: 2 semanas
**Objetivo**: Preparar ambiente e fundações do projeto

### Semana 1: Infraestrutura
- [x] Criar repositório GitHub
- [ ] Configurar estrutura de monorepo (Turborepo/pnpm workspaces)
- [ ] Setup Next.js 14 (app router)
- [ ] Setup Fastify
- [ ] Configurar PostgreSQL + Redis (Docker Compose)
- [ ] Setup Prisma + migrations
- [ ] Configurar ESLint + Prettier + Husky
- [ ] Setup CI/CD (GitHub Actions)
- [ ] Configurar Sentry (error tracking)
- [ ] Setup ambiente de staging (Railway/Render)

### Semana 2: Design System & Auth
- [ ] Criar Design System base (shadcn/ui)
- [ ] Definir paleta de cores e tipografia
- [ ] Criar componentes base (Button, Input, Card, etc.)
- [ ] Implementar autenticação (NextAuth.js)
- [ ] Criar middleware de multi-tenancy
- [ ] Setup de testes (Vitest + Playwright)
- [ ] Documentação inicial (Storybook)

**Entregáveis**:
- ✅ Projeto configurado e rodando local
- ✅ CI/CD funcionando
- ✅ Login funcional
- ✅ Design system documentado

---

## 🎯 Fase 1: MVP Core
**Duração**: 8 semanas (4 sprints)
**Objetivo**: Features essenciais para lançamento

### Sprint 1: Gestão de Colaboradores (Semanas 3-4)

**Backend**:
- [ ] CRUD de empresas
- [ ] CRUD de departamentos
- [ ] CRUD de cargos
- [ ] CRUD de colaboradores
- [ ] Upload de documentos (S3)
- [ ] Validações de CPF/CNPJ
- [ ] Seed de dados de exemplo

**Frontend**:
- [ ] Página de onboarding (configuração inicial da empresa)
- [ ] Dashboard principal (layout)
- [ ] Lista de colaboradores (tabela com filtros)
- [ ] Formulário de cadastro de colaborador
- [ ] Página de detalhes do colaborador
- [ ] Upload de foto e documentos

**Testes**:
- [ ] Unit tests (serviços de colaboradores)
- [ ] E2E (fluxo completo de cadastro)

**Milestone**: Empresa consegue cadastrar e gerenciar colaboradores

---

### Sprint 2: Ponto Eletrônico (Semanas 5-6)

**Backend**:
- [ ] Endpoint de registro de ponto
- [ ] Cálculo de jornada diária
- [ ] Geração de espelho de ponto
- [ ] Validação de horários
- [ ] Cálculo de banco de horas

**Frontend**:
- [ ] Página de registro de ponto (botão de bater ponto)
- [ ] Timer mostrando horário atual
- [ ] Resumo do dia (horas trabalhadas)
- [ ] Espelho de ponto mensal (calendário)
- [ ] Filtros por período
- [ ] Indicadores visuais (completo, falta, ajuste)

**Mobile** (opcional para MVP):
- [ ] App React Native básico
- [ ] Registro de ponto com geolocalização

**Testes**:
- [ ] Unit tests (cálculos de jornada)
- [ ] Integration tests (registros de ponto)
- [ ] E2E (fluxo de batida de ponto)

**Milestone**: Colaboradores conseguem registrar ponto e ver espelho

---

### Sprint 3: Folha de Pagamento - Parte 1 (Semanas 7-8)

**Backend**:
- [ ] Modelo de dados de folha
- [ ] CRUD de tabelas tributárias (INSS, IRRF, FGTS)
- [ ] Calculadora de INSS
- [ ] Calculadora de IRRF
- [ ] Calculadora de FGTS
- [ ] Serviço de cálculo de folha básica
- [ ] Endpoint de iniciar cálculo

**Frontend**:
- [ ] Página de gestão de tabelas tributárias
- [ ] Dashboard de folha do mês
- [ ] Botão de calcular folha
- [ ] Loading state durante cálculo
- [ ] Tabela com resumo por colaborador
- [ ] Indicadores de totais (bruto, líquido, encargos)

**Testes**:
- [ ] Unit tests (calculadoras tributárias)
- [ ] Integration tests (cálculo completo)
- [ ] Testes com casos extremos (salário mínimo, teto INSS, etc.)

**Milestone**: Sistema consegue calcular folha básica corretamente

---

### Sprint 4: Folha de Pagamento - Parte 2 + Holerites (Semanas 9-10)

**Backend**:
- [ ] Integração ponto → folha (horas extras)
- [ ] Cálculo de horas extras (50%, 100%)
- [ ] Gestão de benefícios básicos (VT, VR, VA)
- [ ] Desconto de benefícios na folha
- [ ] Gerador de PDF de holerite
- [ ] Envio de email com holerite
- [ ] Endpoint de fechar folha

**Frontend**:
- [ ] Página de configuração de benefícios
- [ ] Atribuição de benefícios a colaboradores
- [ ] Detalhamento de folha por colaborador
- [ ] Preview de holerite
- [ ] Modal de confirmação de fechamento
- [ ] Página de histórico de folhas
- [ ] Download individual de holerite

**Testes**:
- [ ] Unit tests (cálculo de HE)
- [ ] Integration tests (folha completa com benefícios)
- [ ] E2E (fluxo completo: calcular → revisar → fechar → enviar)

**Milestone**: Sistema gera folha completa e envia holerites ✅

---

## 🔧 Fase 2: Features Intermediárias
**Duração**: 6 semanas (3 sprints)
**Objetivo**: Melhorias operacionais e usabilidade

### Sprint 5: Ajustes de Ponto + Banco de Horas (Semanas 11-12)

**Backend**:
- [ ] CRUD de ajustes de ponto
- [ ] Sistema de aprovação (workflow)
- [ ] Notificações (email)
- [ ] Cálculo refinado de banco de horas
- [ ] Compensação automática

**Frontend**:
- [ ] Formulário de solicitação de ajuste
- [ ] Lista de ajustes pendentes (para gestor)
- [ ] Modal de aprovação/rejeição
- [ ] Indicador de banco de horas no espelho
- [ ] Gráfico de evolução do banco

**Testes**:
- [ ] Unit tests (workflow de aprovação)
- [ ] E2E (solicitar → aprovar → atualizar espelho)

**Milestone**: Colaboradores solicitam ajustes e gestores aprovam

---

### Sprint 6: Provisões + Relatórios (Semanas 13-14)

**Backend**:
- [ ] Cálculo de provisões (férias, 13º)
- [ ] Cálculo de encargos patronais
- [ ] Serviço de relatórios
- [ ] Exportação Excel/PDF
- [ ] Agregações e KPIs

**Frontend**:
- [ ] Dashboard executivo refinado
- [ ] Gráficos de evolução de custos
- [ ] Página de relatórios
- [ ] Filtros avançados
- [ ] Exportação de relatórios

**Testes**:
- [ ] Unit tests (cálculo de provisões)
- [ ] Integration tests (relatórios)

**Milestone**: Gestores têm visibilidade financeira completa

---

### Sprint 7: App Mobile + Dependentes (Semanas 15-16)

**Mobile**:
- [ ] Login
- [ ] Registro de ponto offline-first
- [ ] Espelho de ponto
- [ ] Notificações push
- [ ] Holerite no app
- [ ] Publicar beta (TestFlight/Play Store Beta)

**Backend**:
- [ ] CRUD de dependentes
- [ ] Integração dependentes ↔ benefícios
- [ ] Atualização de cálculos de IRRF

**Frontend**:
- [ ] Página de gestão de dependentes
- [ ] Formulário de cadastro de dependente
- [ ] Vinculação com benefícios

**Testes**:
- [ ] Mobile E2E (Detox)

**Milestone**: App mobile funcional + gestão de dependentes

---

## 🎨 Fase 3: Features Avançadas
**Duração**: 6 semanas (3 sprints)
**Objetivo**: Diferenciais competitivos

### Sprint 8: Avaliação de Desempenho (Semanas 17-18)

**Backend**:
- [ ] CRUD de ciclos de avaliação
- [ ] CRUD de competências
- [ ] Sistema de avaliações (360º)
- [ ] Cálculo de scores
- [ ] Notificações

**Frontend**:
- [ ] Criação de ciclo de avaliação
- [ ] Template de competências
- [ ] Formulário de avaliação
- [ ] Dashboard de progresso
- [ ] Relatório de avaliações

**Testes**:
- [ ] Unit tests (cálculo de scores)
- [ ] E2E (fluxo completo de avaliação)

**Milestone**: Ciclos de avaliação funcionais

---

### Sprint 9: Feed Social + Engajamento (Semanas 19-20)

**Backend**:
- [ ] CRUD de posts
- [ ] Sistema de likes e comentários
- [ ] Notificações em tempo real (WebSockets)
- [ ] Filtros de visibilidade
- [ ] Moderação

**Frontend**:
- [ ] Página de feed
- [ ] Criar post (rich text)
- [ ] Upload de imagens
- [ ] Comentários e likes
- [ ] Notificações em tempo real

**Testes**:
- [ ] Integration tests (posts e interações)
- [ ] E2E (fluxo completo de publicação)

**Milestone**: Feed social funcional e engajador

---

### Sprint 10: EPIs + Integrações (Semanas 21-22)

**Backend**:
- [ ] CRUD de equipamentos
- [ ] Controle de estoque
- [ ] Registro de entregas
- [ ] Gerador de termo de responsabilidade
- [ ] Alertas de validade de CA

**Frontend**:
- [ ] Gestão de EPIs
- [ ] Registro de entrega
- [ ] Assinatura digital
- [ ] Relatório de conformidade

**Integrações** (início):
- [ ] Webhook de eSocial (preparação)
- [ ] API pública (docs)

**Testes**:
- [ ] Unit tests (controle de estoque)
- [ ] E2E (fluxo de entrega de EPI)

**Milestone**: Controle completo de EPIs + API documentada

---

## 🎬 Fase 4: Beta & Launch
**Duração**: 4 semanas (2 sprints)
**Objetivo**: Estabilização e lançamento

### Sprint 11: Beta Testing (Semanas 23-24)

**Atividades**:
- [ ] Recrutamento de 5-10 empresas beta
- [ ] Onboarding guiado
- [ ] Coleta de feedback
- [ ] Correção de bugs críticos
- [ ] Ajustes de UX
- [ ] Performance optimization
- [ ] Security audit
- [ ] Penetration testing

**Melhorias**:
- [ ] Tooltips e ajuda contextual
- [ ] Vídeos tutoriais
- [ ] Documentação completa
- [ ] FAQ

**Milestone**: Produto estável com feedback positivo

---

### Sprint 12: Launch Preparation (Semanas 25-26)

**Técnico**:
- [ ] Load testing (k6/Artillery)
- [ ] Otimização de queries (índices)
- [ ] Setup de CDN
- [ ] Backup automatizado
- [ ] Disaster recovery plan
- [ ] Monitoring e alertas (Datadog/New Relic)

**Marketing**:
- [ ] Landing page
- [ ] Vídeo demo
- [ ] Case studies (beta users)
- [ ] Pricing page
- [ ] Política de privacidade / Termos de uso

**Lançamento**:
- [ ] Deploy em produção
- [ ] Announcement (redes sociais, Product Hunt)
- [ ] Press release
- [ ] Onboarding dos primeiros clientes
- [ ] Suporte ao cliente (Intercom/Zendesk)

**Milestone**: 🚀 Orbit lançado publicamente!

---

## 📊 Definition of Done (DoD)

Cada feature só é considerada "pronta" quando:

✅ **Código**:
- [ ] Implementado conforme requisitos
- [ ] Code review aprovado (2+ aprovações)
- [ ] Sem code smells críticos (SonarQube)

✅ **Testes**:
- [ ] Unit tests (coverage > 80%)
- [ ] Integration tests (casos principais)
- [ ] E2E tests (happy path)
- [ ] Testes manuais (QA)

✅ **Documentação**:
- [ ] API documentada (se aplicável)
- [ ] README atualizado
- [ ] Comments em código complexo
- [ ] Storybook atualizado (componentes)

✅ **Deploy**:
- [ ] Merged na branch `develop`
- [ ] Deploy em staging aprovado
- [ ] Sem erros no Sentry
- [ ] Performance aceitável (Core Web Vitals)

✅ **UX**:
- [ ] Design aprovado pelo designer
- [ ] Responsivo (mobile, tablet, desktop)
- [ ] Acessível (WCAG 2.1 Level A mínimo)
- [ ] Loading states implementados

---

## 🎯 Releases Planejados

### v0.1.0 - MVP Alpha (Semana 10)
**Interno**: Teste com equipe interna
- ✅ Cadastro de colaboradores
- ✅ Ponto eletrônico básico
- ✅ Cálculo de folha básica
- ✅ Holerites

### v0.5.0 - Closed Beta (Semana 16)
**Externo**: 5-10 empresas beta
- ✅ Features do MVP
- ✅ Ajustes de ponto
- ✅ Banco de horas
- ✅ Provisões e relatórios
- ✅ App mobile

### v1.0.0 - Public Launch (Semana 26)
**Público**: Lançamento oficial
- ✅ Todas features anteriores
- ✅ Avaliação de desempenho
- ✅ Feed social
- ✅ Controle de EPIs
- ✅ Documentação completa
- ✅ Onboarding guiado

### v1.1.0 - Post-Launch (Semana 30)
**Melhorias baseadas em feedback**
- ⏭️ Integrações (eSocial, contabilidade)
- ⏭️ Relatórios customizáveis
- ⏭️ White-label avançado
- ⏭️ API pública completa

---

## 📈 Métricas de Sucesso (KPIs)

### Desenvolvimento
- **Velocity**: 40-60 story points por sprint
- **Bug rate**: < 5 bugs críticos por sprint
- **Code coverage**: > 80%
- **Deploy frequency**: Pelo menos 2x por semana

### Produto (Pós-Launch)
- **Onboarding success rate**: > 80% completam setup
- **DAU/MAU**: > 40% (daily/monthly active users)
- **Churn rate**: < 5% ao mês
- **NPS**: > 50
- **Time to value**: < 30 minutos (primeiro holerite gerado)

### Técnico
- **Uptime**: > 99.5%
- **Response time (p95)**: < 500ms
- **Error rate**: < 0.1%
- **Page load (LCP)**: < 2.5s

---

## 🚧 Riscos e Mitigações

### Risco 1: Complexidade dos Cálculos Tributários
**Impacto**: Alto
**Probabilidade**: Média
**Mitigação**:
- Consultor tributário revisando cálculos
- Suite extensiva de testes com casos reais
- Validação com contadores parceiros

### Risco 2: Performance com Grande Volume de Dados
**Impacto**: Alto
**Probabilidade**: Baixa
**Mitigação**:
- Load testing desde cedo
- Otimização de queries (índices, cache)
- Particionamento de tabelas (se necessário)

### Risco 3: Mudanças na Legislação
**Impacto**: Médio
**Probabilidade**: Alta
**Mitigação**:
- Sistema de tabelas configuráveis
- Processo ágil de atualização
- Alertas para clientes sobre mudanças

### Risco 4: Segurança (LGPD)
**Impacto**: Crítico
**Probabilidade**: Baixa
**Mitigação**:
- Security audit antes do launch
- Criptografia de dados sensíveis
- Audit logs completos
- Penetration testing regular

---

## 🎓 Onboarding da Equipe

### Semana 1 (Dev):
- [ ] Setup do ambiente local
- [ ] Leitura da documentação (4 docs)
- [ ] Code walkthrough
- [ ] Primeiro PR (bug fix simples)

### Semana 2:
- [ ] Feature pequena (US simples)
- [ ] Pair programming
- [ ] Code review de outros PRs

### Semana 3+:
- [ ] Features normais
- [ ] Rotação de revisões
- [ ] Ownership de módulos

---

## 📚 Próximos Passos Imediatos

### Esta Semana:
1. ✅ Finalizar planejamento (este doc)
2. ⏭️ Criar repositório no GitHub
3. ⏭️ Setup inicial do monorepo
4. ⏭️ Configurar Docker Compose (Postgres + Redis)
5. ⏭️ Primeira reunião de sprint planning

### Próxima Semana:
1. ⏭️ Iniciar Sprint 0 (Setup)
2. ⏭️ Designer: Criar design system no Figma
3. ⏭️ Backend: Setup Fastify + Prisma
4. ⏭️ Frontend: Setup Next.js + shadcn/ui
5. ⏭️ DevOps: Configurar CI/CD

---

## 🎉 Celebrações Planejadas

- ✅ **Fim do Setup**: Pizza team
- ✅ **MVP Alpha funcionando**: Happy hour
- ✅ **Closed Beta lançado**: Jantar de equipe
- ✅ **Public Launch**: 🍾 Festa de lançamento!

---

**Status**: Planejamento Completo ✅
**Próxima Ação**: Começar a codar! 🚀
