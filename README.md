# Orbit - ERP de Gestão de RH

<div align="center">

**Sistema ERP completo para gestão de Recursos Humanos**
*Desenvolvido para pequenas e médias empresas brasileiras*

[![Status](https://img.shields.io/badge/status-planning-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()
[![TypeScript](https://img.shields.io/badge/typescript-5.0+-blue)]()

[Documentação](#-documentação) • [Features](#-features) • [Tech Stack](#-tech-stack) • [Roadmap](#-roadmap)

</div>

---

## 🎯 Sobre o Projeto

**Orbit** é um sistema ERP moderno e completo focado em Gestão de Recursos Humanos, desenvolvido especificamente para pequenas e médias empresas brasileiras.

O sistema oferece gerenciamento completo desde o controle de ponto eletrônico até o fechamento mensal da folha de pagamento, com cálculos automáticos de encargos, provisões, benefícios, e ferramentas de engajamento da equipe.

### 💡 Proposta de Valor

- ✅ **Gestão Completa**: Desde o ponto eletrônico até o fechamento mensal da folha
- 🔧 **Flexível**: Sistema tributário configurável por tabelas para atender diferentes regimes
- 👤 **Personalizável**: Tratamento individualizado por colaborador
- 🎨 **Moderno**: Interface profissional e tecnologias atuais
- 📱 **Engajamento**: Feed social para comunicação e interação da equipe

---

## 🚀 Features

### 💰 Gestão de Folha de Pagamento
- Cálculo automático de salários com todos os encargos (INSS, IRRF, FGTS)
- Controle de horas extras (50%, 100%)
- Gestão de comissões e bonificações
- Controle de provisões (férias, 13º salário)
- Geração automática de holerites (PDF)
- Fechamento mensal automatizado
- Tratamento individualizado por colaborador

### ⏰ Controle de Ponto Eletrônico
- Registro de ponto (web, mobile, biometria)
- Espelho de ponto mensal
- Banco de horas automático
- Solicitação e aprovação de ajustes
- Gestão de ausências e licenças
- Integração automática com folha

### 🎁 Benefícios e Convênios
- Gestão de VT, VR, VA, plano de saúde, etc.
- Controle de elegibilidade por cargo/departamento
- Portal do colaborador para consulta
- Gestão de dependentes
- Integração com fornecedores

### 👔 Uniformes e EPIs
- Controle de estoque
- Registro de entregas com assinatura digital
- Termo de responsabilidade
- Alertas de vencimento de CA
- Relatórios de conformidade NR

### 📊 Avaliação de Desempenho
- Ciclos de avaliação configuráveis
- Múltiplos modelos (90º, 180º, 360º)
- Definição de metas e KPIs
- PDI (Plano de Desenvolvimento Individual)
- Dashboards e relatórios

### 📱 Feed Social / Engajamento
- Mural de comunicados
- Feed de aniversários e conquistas
- Curtidas e comentários
- Pesquisas de clima
- Gamificação

### 📈 Relatórios e Dashboards
- Dashboard executivo (custos, headcount, turnover)
- Análise de custos com pessoal
- Projeções de despesas
- Relatórios para órgãos (SEFIP, CAGED, eSocial)
- Exportação (PDF, Excel, CSV)

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Next.js 14+ (App Router)
- **Linguagem**: TypeScript 5+
- **Estilização**: Tailwind CSS + shadcn/ui
- **Estado**: Zustand + React Query
- **Formulários**: React Hook Form + Zod
- **Tabelas**: TanStack Table
- **Gráficos**: Recharts

### Backend
- **Framework**: Fastify
- **Linguagem**: TypeScript 5+
- **ORM**: Prisma
- **Validação**: Zod
- **Auth**: NextAuth.js
- **Jobs**: BullMQ

### Database & Cache
- **Database**: PostgreSQL 16+
- **Cache**: Redis 7+
- **Storage**: AWS S3 / MinIO

### Infrastructure
- **Containerização**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoring**: Sentry + Better Stack
- **Hospedagem**: Railway / Render (MVP) → AWS (Scale)

---

## 📚 Documentação

A documentação completa do projeto está organizada em:

1. **[PLANNING_GUIDE.md](./PLANNING_GUIDE.md)** - Guia geral de planejamento
2. **[01-CONCEPT.md](./docs/01-CONCEPT.md)** - Conceito e visão do produto
3. **[02-REQUIREMENTS.md](./docs/02-REQUIREMENTS.md)** - Requisitos e user stories
4. **[03-ARCHITECTURE.md](./docs/03-ARCHITECTURE.md)** - Arquitetura técnica
5. **[04-DATABASE.md](./docs/04-DATABASE.md)** - Modelo de dados (Prisma schema)
6. **[05-API.md](./docs/05-API.md)** - Documentação da API REST
7. **[06-ROADMAP.md](./docs/06-ROADMAP.md)** - Roadmap de desenvolvimento

---

## 🗓️ Roadmap

### Fase 0: Setup (2 semanas) ✅
- Infraestrutura e ambiente
- Design system
- Autenticação

### Fase 1: MVP Core (8 semanas) - Em Planejamento
- Gestão de colaboradores
- Ponto eletrônico
- Folha de pagamento básica
- Holerites

### Fase 2: Features Intermediárias (6 semanas)
- Ajustes de ponto
- Banco de horas
- Provisões e relatórios
- App mobile

### Fase 3: Features Avançadas (6 semanas)
- Avaliação de desempenho
- Feed social
- Controle de EPIs
- API pública

### Fase 4: Beta & Launch (4 semanas)
- Beta testing
- Performance optimization
- Lançamento público 🚀

**Ver detalhes**: [06-ROADMAP.md](./docs/06-ROADMAP.md)

---

## 🚀 Getting Started

### Pré-requisitos

- Node.js 20+
- pnpm 8+
- Docker & Docker Compose
- PostgreSQL 16+
- Redis 7+

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/orbit.git
cd orbit

# Instale as dependências
pnpm install

# Configure as variáveis de ambiente
cp .env.example .env

# Suba os serviços (Postgres + Redis)
docker-compose up -d

# Execute as migrações
pnpm prisma migrate dev

# Seed do banco (dados de exemplo)
pnpm prisma db seed

# Inicie o servidor de desenvolvimento
pnpm dev
```

O frontend estará rodando em `http://localhost:3000`
O backend estará rodando em `http://localhost:3001`

---

## 🧪 Testes

```bash
# Testes unitários
pnpm test

# Testes com coverage
pnpm test:coverage

# Testes E2E
pnpm test:e2e

# Lint
pnpm lint

# Type check
pnpm type-check
```

---

## 📦 Estrutura do Projeto

```
orbit/
├── apps/
│   ├── web/                 # Frontend Next.js
│   └── api/                 # Backend Fastify
├── packages/
│   ├── ui/                  # Design system (shadcn/ui)
│   ├── database/            # Prisma schema e migrations
│   ├── config/              # Configurações compartilhadas
│   └── types/               # TypeScript types compartilhados
├── docs/                    # Documentação
├── docker-compose.yml       # Serviços locais
└── package.json
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Add: Minha nova feature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

### Convenções

- **Commits**: Seguir [Conventional Commits](https://www.conventionalcommits.org/)
- **Code Style**: ESLint + Prettier
- **Branches**: `feature/`, `fix/`, `docs/`, `refactor/`

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](./LICENSE) para mais detalhes.

---

## 👥 Time

- **Product Owner**: [Nome]
- **Tech Lead**: [Nome]
- **Developers**: [Nomes]
- **Designer**: [Nome]

---

## 📧 Contato

- **Email**: contato@orbit.app
- **Website**: https://orbit.app
- **LinkedIn**: [LinkedIn da empresa]

---

## 🌟 Apoie o Projeto

Se este projeto te ajudou, considere dar uma ⭐ no repositório!

---

<div align="center">

**Feito com ❤️ para PMEs brasileiras**

[Voltar ao topo](#orbit---erp-de-gestão-de-rh)

</div>
