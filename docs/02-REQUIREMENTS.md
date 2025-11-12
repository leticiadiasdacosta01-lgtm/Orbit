# Requisitos Funcionais - Orbit ERP

## 📋 User Stories e Critérios de Aceitação

---

## Módulo 1: Gestão de Folha de Pagamento

### US-001: Cadastro de Colaborador
**Como** gestor de RH
**Eu quero** cadastrar um novo colaborador no sistema
**Para** gerenciar seus dados e folha de pagamento

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema permite cadastrar dados pessoais (nome, CPF, RG, data nascimento, etc.)
- [ ] Sistema valida CPF único (não pode duplicar)
- [ ] Sistema permite cadastrar dados contratuais (cargo, salário, data admissão, tipo contrato)
- [ ] Sistema permite definir regime tributário individual
- [ ] Sistema permite configurar benefícios aplicáveis
- [ ] Sistema permite upload de documentos (foto, RG, CPF, CTPS, etc.)
- [ ] Sistema gera automaticamente número de matrícula único
- [ ] Sistema permite definir departamento e gestor direto
- [ ] Sistema valida campos obrigatórios antes de salvar
- [ ] Sistema registra data/hora e usuário que criou o cadastro

**Regras de Negócio**:
- CPF deve ser válido e único
- Data de admissão não pode ser futura
- Salário deve ser >= salário mínimo vigente
- Tipo de contrato: CLT, PJ, Estágio, Temporário, Intermitente

---

### US-002: Cálculo Automático de Folha
**Como** gestor de DP
**Eu quero** calcular automaticamente a folha de pagamento do mês
**Para** reduzir erros e tempo de processamento

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema calcula salário bruto considerando: salário base + comissões + horas extras + adicionais
- [ ] Sistema calcula INSS usando tabela progressiva vigente
- [ ] Sistema calcula IRRF usando tabela progressiva com dependentes
- [ ] Sistema calcula FGTS (8%)
- [ ] Sistema aplica descontos (VT, plano saúde, faltas, atrasos)
- [ ] Sistema calcula salário líquido final
- [ ] Sistema permite ajustes manuais com justificativa
- [ ] Sistema exibe detalhamento de cada cálculo
- [ ] Sistema valida cálculos contra regras tributárias
- [ ] Sistema permite recalcular folha antes do fechamento

**Regras de Negócio**:
- Usar tabelas tributárias vigentes no mês de referência
- INSS: cálculo progressivo com teto
- IRRF: base de cálculo = salário bruto - INSS - dependentes - pensão alimentícia
- VT: desconto máximo de 6% do salário base
- Horas extras: 50% dias úteis, 100% domingos/feriados
- Adicional noturno: 20% sobre hora normal (22h-5h)

---

### US-003: Gestão de Horas Extras
**Como** gestor de RH
**Eu quero** registrar e calcular horas extras dos colaboradores
**Para** remunerar corretamente o tempo trabalhado além da jornada

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema calcula automaticamente HE baseado no ponto eletrônico
- [ ] Sistema permite lançamento manual de HE com justificativa
- [ ] Sistema diferencia HE 50% (dias úteis) e 100% (domingos/feriados)
- [ ] Sistema considera banco de horas (compensação antes de pagamento)
- [ ] Sistema exibe relatório de HE por colaborador/período
- [ ] Sistema permite aprovar/reprovar HE lançadas
- [ ] Sistema integra HE aprovadas automaticamente na folha
- [ ] Sistema alerta quando colaborador excede limite legal de HE
- [ ] Sistema permite definir regras de HE por cargo/departamento

**Regras de Negócio**:
- Limite legal: 2h extras por dia
- HE dias úteis: valor hora × 1.5
- HE domingos/feriados: valor hora × 2.0
- Banco de horas: compensação em até 6 meses
- Adicional noturno + HE: acumula percentuais

---

### US-004: Controle de Encargos e Provisões
**Como** contador
**Eu quero** visualizar e exportar encargos e provisões mensais
**Para** fazer lançamentos contábeis corretos

**Prioridade**: 🟡 Média

**Critérios de Aceitação**:
- [ ] Sistema calcula provisões de férias (1/12 × salário × 1.33)
- [ ] Sistema calcula provisões de 13º salário (1/12 × salário)
- [ ] Sistema calcula FGTS mensal (8% + 2% multa provisão)
- [ ] Sistema calcula INSS patronal (tabela por faixa de risco)
- [ ] Sistema calcula terceiros (Sistema S: SESI, SENAI, etc.)
- [ ] Sistema exibe dashboard de custos totais com pessoal
- [ ] Sistema permite exportar relatório para contabilidade (Excel/CSV)
- [ ] Sistema compara provisões vs. valores realizados
- [ ] Sistema alerta sobre divergências > 5%

**Regras de Negócio**:
- Férias: provisão mensal de 1/12 do salário + 1/3 constitucional
- 13º: provisão mensal de 1/12 do salário
- INSS patronal: varia por atividade (RAT: 1%, 2% ou 3%)
- Terceiros (Sistema S): ~5.8% sobre folha (varia por regime)

---

### US-005: Geração de Holerite
**Como** colaborador
**Eu quero** visualizar e baixar meu holerite mensal
**Para** conferir meus pagamentos e descontos

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema gera holerite em PDF com identidade visual profissional
- [ ] Holerite exibe: proventos, descontos, base de cálculos, líquido
- [ ] Holerite exibe dados da empresa e do colaborador
- [ ] Sistema envia automaticamente por email no fechamento
- [ ] Colaborador acessa holerites de meses anteriores (histórico)
- [ ] Sistema permite recibo de entrega digital
- [ ] Sistema gera PDF com QR Code para validação
- [ ] Holerite pode ser exportado para pasta compartilhada
- [ ] Sistema notifica colaborador quando holerite está disponível

**Regras de Negócio**:
- Modelo deve seguir padrão legal brasileiro
- Deve conter: razão social, CNPJ, matrícula, cargo, período
- Separar claramente: vencimentos, descontos, base INSS/IRRF/FGTS

---

## Módulo 2: Controle de Ponto Eletrônico

### US-006: Registro de Ponto
**Como** colaborador
**Eu quero** registrar meu ponto de entrada/saída
**Para** ter minha jornada de trabalho controlada

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema permite registro via web (desktop/mobile)
- [ ] Sistema permite registro via app mobile com geolocalização
- [ ] Sistema permite integração com relógio biométrico
- [ ] Sistema exibe horário sincronizado do servidor
- [ ] Sistema registra: data/hora, IP, geolocalização, tipo (entrada/intervalo/saída)
- [ ] Sistema impede duplicação de registro no mesmo minuto
- [ ] Sistema permite ajuste de ponto com justificativa (pendente aprovação)
- [ ] Sistema exibe resumo do dia (horas trabalhadas, banco de horas)
- [ ] Sistema notifica colaborador se esquecer de bater ponto

**Regras de Negócio**:
- Mínimo 4 marcações/dia: entrada, saída almoço, retorno almoço, saída
- Tolerância de atraso: 10 minutos (configurável)
- Geolocalização: validar se está em raio permitido (opcional)
- Offline: permitir registro offline e sincronizar depois (mobile)

---

### US-007: Espelho de Ponto
**Como** colaborador
**Eu quero** visualizar meu espelho de ponto mensal
**Para** conferir minha frequência antes do fechamento

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema exibe calendário mensal com todas as marcações
- [ ] Sistema calcula: horas trabalhadas, HE, faltas, atrasos, banco de horas
- [ ] Sistema destaca dias com inconsistências (falta marcação, ajustes)
- [ ] Sistema permite exportar espelho em PDF
- [ ] Sistema exibe legenda clara (cores para cada tipo de dia)
- [ ] Sistema permite filtrar por período
- [ ] Sistema exibe saldo de banco de horas acumulado
- [ ] Colaborador pode solicitar ajustes diretamente do espelho
- [ ] Gestor pode aprovar ajustes diretamente do espelho

**Regras de Negócio**:
- Cores: verde (completo), amarelo (ajustes), vermelho (faltas), azul (férias/licença)
- Banco de horas: positivo (crédito) ou negativo (débito)
- Espelho fechado após processamento da folha (somente leitura)

---

### US-008: Solicitação de Ajuste de Ponto
**Como** colaborador
**Eu quero** solicitar correção de ponto esquecido ou incorreto
**Para** manter meu registro de frequência correto

**Prioridade**: 🟡 Média

**Critérios de Aceitação**:
- [ ] Sistema permite solicitar ajuste de ponto
- [ ] Sistema exige justificativa obrigatória
- [ ] Sistema permite anexar comprovante (opcional)
- [ ] Sistema envia notificação para gestor aprovar
- [ ] Gestor visualiza histórico de ajustes do colaborador
- [ ] Sistema permite aprovar/reprovar com comentário
- [ ] Sistema notifica colaborador sobre status
- [ ] Sistema registra trilha de auditoria completa
- [ ] Sistema permite definir aprovadores por hierarquia

**Regras de Negócio**:
- Prazo máximo para solicitar: até 5 dias úteis após a data
- Ajustes aprovados atualizam automaticamente o espelho
- Ajustes reprovados podem ser re-solicitados com nova justificativa
- Limite: máximo 3 ajustes por mês (configu configurável)

---

## Módulo 3: Benefícios e Convênios

### US-009: Gestão de Benefícios
**Como** gestor de RH
**Eu quero** configurar benefícios oferecidos pela empresa
**Para** automatizar concessão e descontos na folha

**Prioridade**: 🟡 Média

**Critérios de Aceitação**:
- [ ] Sistema permite cadastrar tipos de benefícios (VT, VR, VA, plano saúde, etc.)
- [ ] Sistema permite definir valor e percentual de desconto
- [ ] Sistema permite definir elegibilidade (todos, por cargo, por departamento)
- [ ] Sistema permite definir regras de coparticipação
- [ ] Sistema integra automaticamente descontos na folha
- [ ] Sistema permite incluir dependentes em benefícios
- [ ] Sistema permite ativar/desativar benefício por colaborador
- [ ] Sistema exibe relatório de custos com benefícios
- [ ] Sistema permite exportar dados para fornecedores

**Regras de Negócio**:
- VT: desconto máximo 6% do salário base
- VR/VA: sem desconto ou com coparticipação (configurável)
- Plano saúde: valor fixo ou % sobre salário
- Cada benefício pode ter regras específicas de desconto

---

### US-010: Portal do Colaborador - Benefícios
**Como** colaborador
**Eu quero** visualizar meus benefícios ativos
**Para** saber o que tenho direito e valores

**Prioridade**: 🟢 Baixa

**Critérios de Aceitação**:
- [ ] Sistema exibe lista de benefícios ativos
- [ ] Sistema exibe valor/crédito disponível de cada benefício
- [ ] Sistema exibe histórico de utilização (se aplicável)
- [ ] Sistema permite solicitar inclusão de dependentes
- [ ] Sistema exibe contatos de fornecedores/convênios
- [ ] Sistema permite baixar carteirinhas digitais
- [ ] Sistema notifica sobre novos benefícios disponíveis

---

## Módulo 4: Uniformes e EPIs

### US-011: Controle de Entrega de EPIs
**Como** técnico de segurança
**Eu quero** registrar entrega de EPIs aos colaboradores
**Para** manter conformidade com NRs e rastreabilidade

**Prioridade**: 🟢 Baixa

**Critérios de Aceitação**:
- [ ] Sistema permite cadastrar EPIs (tipo, CA, validade)
- [ ] Sistema controla estoque de EPIs
- [ ] Sistema registra entregas (data, quantidade, assinatura digital)
- [ ] Sistema gera Termo de Responsabilidade (PDF)
- [ ] Sistema alerta sobre validade próxima do CA
- [ ] Sistema alerta sobre estoque baixo
- [ ] Sistema exibe histórico de entregas por colaborador
- [ ] Sistema gera relatório para auditorias

**Regras de Negócio**:
- EPI deve ter CA (Certificado de Aprovação) válido
- Colaborador deve assinar termo de recebimento
- Sistema deve alertar 30 dias antes do vencimento do CA

---

## Módulo 5: Avaliação de Desempenho

### US-012: Criação de Ciclo de Avaliação
**Como** gestor de RH
**Eu quero** criar um ciclo de avaliação de desempenho
**Para** avaliar a equipe periodicamente

**Prioridade**: 🟡 Média

**Critérios de Aceitação**:
- [ ] Sistema permite criar ciclo (nome, período, tipo)
- [ ] Sistema suporta: autoavaliação, avaliação por gestor, 360º
- [ ] Sistema permite definir competências a avaliar
- [ ] Sistema permite definir pesos por competência
- [ ] Sistema permite definir participantes (individual, departamento, toda empresa)
- [ ] Sistema envia notificações automáticas aos avaliadores
- [ ] Sistema permite definir prazos
- [ ] Sistema bloqueia edições após prazo

**Regras de Negócio**:
- Tipos: 90º (gestor), 180º (gestor + auto), 360º (gestor + auto + pares)
- Escalas: 1-5, 1-10, descritiva (insatisfatório a excelente)
- Competências podem ser técnicas ou comportamentais

---

### US-013: Realização de Avaliação
**Como** gestor
**Eu quero** avaliar meu colaborador
**Para** fornecer feedback sobre seu desempenho

**Prioridade**: 🟡 Média

**Critérios de Aceitação**:
- [ ] Sistema exibe formulário com competências a avaliar
- [ ] Sistema permite atribuir nota/conceito por competência
- [ ] Sistema permite adicionar comentários por competência
- [ ] Sistema calcula nota final automaticamente
- [ ] Sistema permite salvar rascunho
- [ ] Sistema valida preenchimento completo antes de finalizar
- [ ] Sistema permite anexar PDI (Plano de Desenvolvimento)
- [ ] Colaborador visualiza feedback após finalização
- [ ] Sistema gera relatório consolidado

**Regras de Negócio**:
- Avaliação só pode ser editada até o prazo final
- Colaborador só visualiza após gestor finalizar
- Nota final: média ponderada por peso de cada competência

---

## Módulo 6: Feed Social / Engajamento

### US-014: Publicar no Feed
**Como** gestor de RH
**Eu quero** publicar comunicados no feed
**Para** engajar e informar a equipe

**Prioridade**: 🟢 Baixa

**Critérios de Aceitação**:
- [ ] Sistema permite criar publicação (texto, imagem, vídeo, arquivo)
- [ ] Sistema suporta markdown/formatação básica
- [ ] Sistema permite mencionar colaboradores (@nome)
- [ ] Sistema permite adicionar hashtags
- [ ] Sistema permite definir visibilidade (todos, departamento, específicos)
- [ ] Sistema permite fixar publicações importantes
- [ ] Sistema permite agendar publicações
- [ ] Sistema envia notificação aos destinatários
- [ ] Sistema permite editar/excluir publicação

**Regras de Negócio**:
- Publicações fixadas aparecem no topo
- Limite de 5 publicações fixadas simultaneamente
- Apenas gestores/RH podem publicar conteúdo oficial

---

### US-015: Interagir no Feed
**Como** colaborador
**Eu quero** curtir e comentar publicações
**Para** interagir com meus colegas e empresa

**Prioridade**: 🟢 Baixa

**Critérios de Aceitação**:
- [ ] Sistema permite curtir publicações
- [ ] Sistema permite comentar
- [ ] Sistema permite responder comentários (thread)
- [ ] Sistema permite reagir com emojis
- [ ] Sistema notifica autor sobre interações
- [ ] Sistema permite denunciar conteúdo inapropriado
- [ ] Sistema permite ocultar publicações (usuário)
- [ ] Gestor pode moderar comentários

**Regras de Negócio**:
- Comentários podem ser moderados antes de publicar (opcional)
- Sistema deve filtrar palavras impróprias (configurável)

---

## Módulo 7: Configurações e Tabelas

### US-016: Gestão de Tabelas Tributárias
**Como** administrador do sistema
**Eu quero** atualizar tabelas tributárias (INSS, IRRF)
**Para** manter cálculos sempre corretos e atualizados

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema permite cadastrar/editar tabelas de INSS
- [ ] Sistema permite cadastrar/editar tabelas de IRRF
- [ ] Sistema permite definir vigência (data início/fim)
- [ ] Sistema valida que não há gaps entre vigências
- [ ] Sistema usa tabela vigente automaticamente nos cálculos
- [ ] Sistema mantém histórico de todas as tabelas
- [ ] Sistema permite simular cálculo com tabela específica
- [ ] Sistema importa tabelas via CSV/Excel
- [ ] Sistema notifica usuários sobre atualização de tabelas

**Regras de Negócio**:
- Sempre deve haver uma tabela vigente
- Cálculos retroativos usam tabela vigente na competência
- Atualização de tabela não recalcula folhas fechadas automaticamente

---

### US-017: Configurações da Empresa
**Como** administrador
**Eu quero** configurar dados e regras da minha empresa
**Para** personalizar o sistema às minhas necessidades

**Prioridade**: 🔴 Alta

**Critérios de Aceitação**:
- [ ] Sistema permite cadastrar dados da empresa (razão, CNPJ, endereço)
- [ ] Sistema permite definir regime tributário (Simples, Presumido, Real)
- [ ] Sistema permite configurar jornada de trabalho padrão
- [ ] Sistema permite definir tolerância de atraso
- [ ] Sistema permite configurar aprovadores de ponto/ajustes
- [ ] Sistema permite definir dia de fechamento da folha
- [ ] Sistema permite personalizar logo e cores (white-label básico)
- [ ] Sistema permite configurar integrações externas
- [ ] Sistema permite definir feriados municipais/estaduais

**Regras de Negócio**:
- CNPJ deve ser válido e único na plataforma
- Regime tributário afeta cálculos de encargos
- Mudanças de configuração não afetam competências fechadas

---

## 📊 Priorização de Features (MVP)

### Fase 1 - MVP Core (3 meses)
**Features Essenciais para Lançamento**

1. ✅ Autenticação e controle de acesso
2. ✅ Cadastro de empresa e colaboradores
3. ✅ Registro de ponto (web)
4. ✅ Espelho de ponto
5. ✅ Cálculo de folha básico (salário + INSS + IRRF + FGTS)
6. ✅ Geração de holerite (PDF)
7. ✅ Gestão de tabelas tributárias
8. ✅ Dashboard básico
9. ✅ Gestão de benefícios (VT, VR, VA)

### Fase 2 - Features Intermediárias (2 meses)
10. ⏭️ Controle de horas extras
11. ⏭️ Banco de horas
12. ⏭️ Ajustes de ponto com aprovação
13. ⏭️ Cálculos de provisões
14. ⏭️ Relatórios gerenciais
15. ⏭️ App mobile para ponto
16. ⏭️ Gestão de dependentes

### Fase 3 - Features Avançadas (2 meses)
17. ⏭️ Avaliação de desempenho
18. ⏭️ Feed social
19. ⏭️ Controle de EPIs
20. ⏭️ Integração eSocial
21. ⏭️ API pública
22. ⏭️ Relatórios customizáveis

---

## 🔒 Requisitos de Segurança (LGPD)

### Tratamento de Dados Sensíveis
- [ ] Criptografia de dados pessoais em repouso (AES-256)
- [ ] Criptografia em trânsito (TLS 1.3)
- [ ] Mascaramento de CPF em logs
- [ ] Política de retenção de dados
- [ ] Direito ao esquecimento (exclusão lógica)
- [ ] Exportação de dados pessoais (portabilidade)
- [ ] Audit log de acessos a dados sensíveis
- [ ] Consentimento explícito para coleta de dados
- [ ] DPO (Data Protection Officer) designado

### Controle de Acesso
- [ ] Autenticação multi-fator (2FA)
- [ ] Perfis de acesso (RBAC): Admin, RH, Gestor, Colaborador
- [ ] Sessões com timeout automático (30 min inatividade)
- [ ] Bloqueio após 5 tentativas de login incorretas
- [ ] Política de senha forte (mínimo 8 caracteres, maiúscula, número, símbolo)
- [ ] Histórico de logins (IP, data/hora, dispositivo)

---

**Próximo**: [03-ARCHITECTURE.md](./03-ARCHITECTURE.md)
