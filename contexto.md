# 🧭 Contexto e Arquitetura do Projeto — MonitoramentoBoy

---

## 1. 📖 Descrição do Projeto

O **MonitoramentoBoy** é uma solução para gestão logística, roteirização inteligente e monitoramento em tempo real de entregas urbanas (last-mile delivery). O sistema foi concebido para resolver o descompasso entre a equipe operacional que planeja os pedidos e os entregadores (motoboys) que executam as entregas nas ruas.

A plataforma resolve três desafios centrais:
1. **Otimização de Rotas:** Organização automática das entregas na melhor sequência de paradas, além de fornecer rotas alternativas para contingência em caso de imprevistos.
2. **Monitoramento Ativo de SLA:** Diferenciação visual instantânea entre entregas no prazo e entregas atrasadas ou sob risco de estouro de prazo.
3. **Comunicação em Duas Vias:** O entregador recebe sua lista otimizada com instruções claras no celular, e com um único clique confirma a entrega ou reporta ocorrências, atualizando imediatamente o painel da gestão.

---

## 2. 🎯 Objetivos do Projeto

- **Autonomia Operacional:** Permitir que o gestor cadastre clientes e pedidos e obtenha rotas calculadas e distribuídas instantaneamente.
- **Maximização da Eficiência:** Redução de quilometragem rodada e tempo ocioso dos motoboys através de algoritmos de roteirização.
- **Eliminação de Pontos Cegos:** Visibilidade total sobre quais pedidos estão atrasados, no prazo ou já entregues.
- **Disponibilidade Total e Execução Offline:** Capacidade de funcionar de forma autônoma e resiliente em qualquer dispositivo (desktop ou smartphone), persistindo dados localmente via navegador sem dependência obrigatória de conexão com internet ou servidores externos.

---

## 3. 🏗️ Arquitetura do Projeto

A arquitetura do projeto foi desenhada para suportar tanto uma implantação monolítica autônoma (Single-File Application) quanto uma futura migração para microsserviços ou API REST tradicional.

### 3.1. Visão Geral da Arquitetura

```
+---------------------------------------------------------------------------------+
|                                 MONITORAMENTOBOY                                |
+---------------------------------------------------------------------------------+
|                                                                                 |
|   +-----------------------------------+   +---------------------------------+   |
|   |   PAINEL DO ADMINISTRADOR         |   |   PAINEL DO ENTREGADOR (MOTOBOY)|   |
|   |   - Dashboard de Indicadores      |   |   - Lista do Dia (Sequenciada)  |   |
|   |   - Monitor de Prazos (SLA)       |   |   - Card da Próxima Entrega     |   |
|   |   - Roteirizador & Rotas Alt.     |   |   - Baixa com 1 Clique (Done)   |   |
|   |   - Gestão de Pedidos & Clientes  |   |   - Registro de Ocorrências     |   |
|   +-----------------+-----------------+   +----------------+----------------+   |
|                     |                                      |                    |
|                     +------------------+-------------------+                    |
|                                        |                                        |
|                     +------------------v-------------------+                    |
|                     |          STATE MANAGER EVENT BUS     |                    |
|                     |     (Dispatcher de Eventos Locais)   |                    |
|                     +------------------+-------------------+                    |
|                                        |                                        |
|       +--------------------------------+--------------------------------+       |
|       |                                |                                |       |
|  +----v--------------------+   +-------v----------------+   +-----------v----+  |
|  | ENGINE DE ROTEIRIZAÇÃO  |   | MONITOR DE SLA & TEMPO |   | CANVAS ENGINE  |  |
|  | - Vizinho Mais Próximo  |   | - Cálculo de Delta-T   |   | - Mapa Offline |  |
|  | - Rotas Alternativas    |   | - Classificador Status |   | - Traçado Rotas|  |
|  | - Estimativa de Duração |   |   (No Prazo / Atraso)  |   | - Marcadores   |  |
|  +-------------------------+   +------------------------+   +----------------+  |
|                                        |                                        |
|                     +------------------v-------------------+                    |
|                     |     STORAGE & PERSISTENCE LAYER      |                    |
|                     |   - LocalStorage / Cache Local       |                    |
|                     |   - Schema: Clientes, Pedidos, Rotas |                    |
|                     +--------------------------------------+                    |
+---------------------------------------------------------------------------------+
```

### 3.2. Camadas do Sistema

#### 1. Camada de Apresentação (UI / UX)
- **Modo Duplo Integrado:** Permite alternar instantaneamente entre a visão de **Gestor (Desktop/Tablet)** e a visão de **Entregador (Mobile-First)**.
- **Design System:** Interface moderna, responsiva, com paleta de cores balanceada (Dark Mode suave com destaques em esmeralda, âmbar e coral para status), tipografia legível e microinterações.
- **Mapa Vetorial Offline:** Implementado via HTML5 Canvas e coordenadas cartesianas normalizadas, permitindo visualizar a sede da empresa, os clientes e a rota calculada sem necessidade de consumir APIs pagas ou depender de conexão de rede.

#### 2. Camada de Regras de Negócio e Algoritmos (Core Engine)
- **Módulo de Roteirização:**
  - *Rota Principal Otimizada:* Algoritmo heurístico baseado em busca gulosa e vizinho mais próximo com partida do ponto de distribuição (Hub Central).
  - *Rotas Alternativas:* Variação de sequenciamento com critérios de balanceamento de horários limites (prioridade para pedidos de entrega urgente) e caminhos divergentes.
  - *Estimativa de Tempo e Trajeto:* Cálculo de distâncias baseadas em vetores geográficos e velocidade média urbana de motocicleta.
- **Módulo de SLA e Monitoramento de Prazos:**
  - Varredura periódica e em tempo real dos pedidos em aberto.
  - Classificação automática:
    - 🟢 **No Prazo:** Pedido cuja estimativa de chegada é inferior ao horário limite estabelecido.
    - 🟡 **Alerta / Em Risco:** Pedido com margem de tolerância inferior a 15 minutos do prazo.
    - 🔴 **Atrasado:** Pedido cujo horário limite já expirou sem que a entrega tenha sido confirmada.
    - ✅ **Concluído:** Pedido entregue, registrando carimbo de data/hora (timestamp) e tempo total despendido.

#### 3. Camada de Persistência e Sincronização Local
- Dados persistidos em `localStorage`, garantindo que atualizações de status feitas no painel do entregador reflitam instantaneamente no painel do administrador.
- Inicialização automática com dados de teste representativos (clientes, endereços, coordenadas e pedidos com prazos variados) para demonstração imediata.

---

## 4. 📄 O Arquivo Monolítico Offline (`index.html`)

O arquivo [index.html](file:///c:/Users/admin/Documents/monitormentoboy/index.html) é uma aplicação web autônoma completa (Single File Application) contendo todo o HTML, CSS e JavaScript necessários para a operação do sistema.

### Vantagens do Formato Monolítico Offline:
- **Zero Dependências:** Funciona imediatamente com duplo clique em qualquer navegador moderno (Chrome, Edge, Firefox, Safari) sem necessidade de `npm install`, servidor web ou internet.
- **Portabilidade:** Pode ser distribuído como um único arquivo via pendrive, e-mail ou hospedado diretamente no GitHub Pages ou servidor estático.
- **Resiliência a Falhas de Rede:** Mesmo em zonas com instabilidade de sinal 4G/5G, a aplicação mantém toda a lógica de cálculo de rotas e confirmação de entregas ativa.

---

## 5. ✅ Registro de Progresso do Projeto

> Última atualização: 17/10/2026 — Registro de tudo que foi entregue e o que ainda precisa ser construído.

---

### 5.1. ✅ O QUE FOI FEITO (Concluído)

#### 📄 Documentação e Especificação
| Artefato | Descrição | Status |
|---|---|---|
| [`dor.md`](file:///c:/Users/admin/Documents/monitormentoboy/dor.md) | PRD completo: dores mapeadas, personas, requisitos funcionais/não-funcionais, modelo de dados ER e protótipo de telas | ✅ Concluído |
| [`contexto.md`](file:///c:/Users/admin/Documents/monitormentoboy/contexto.md) | Descrição do projeto, objetivos estratégicos e diagrama completo de arquitetura do sistema | ✅ Concluído |
| [`sprints.md`](file:///c:/Users/admin/Documents/monitormentoboy/sprints.md) | Roadmap ágil com 7 sprints (Sprint 0 a Sprint 6), gráfico Gantt e matriz MoSCoW de priorização | ✅ Concluído |
| [`repositorios_mapas.md`](file:///c:/Users/admin/Documents/monitormentoboy/repositorios_mapas.md) | Pesquisa de repositórios gratuitos de mapas: OpenStreetMap, Leaflet.js, OSRM, Nominatim, OpenRouteService | ✅ Concluído |
| [`rotas_cuiaba_vg.md`](file:///c:/Users/admin/Documents/monitormentoboy/rotas_cuiaba_vg.md) | Guia completo de rotas reais de Cuiabá e Várzea Grande: bairros, ruas, pontes, corredores logísticos e distâncias | ✅ Concluído |

#### 🖥️ Aplicação (MVP Offline)
| Artefato | Descrição | Status |
|---|---|---|
| [`index.html`](file:///c:/Users/admin/Documents/monitormentoboy/index.html) | Aplicação monolítica offline completa (~82KB). Inclui Painel Admin, Painel Motoboy, Mapa Canvas, Roteirizador e Suíte de Testes QA | ✅ Concluído |
| [`iniciar_servidor.ps1`](file:///c:/Users/admin/Documents/monitormentoboy/iniciar_servidor.ps1) | Script PowerShell para iniciar servidor HTTP local na porta 8080 sem precisar de Node.js ou Python | ✅ Concluído |

#### 🗺️ Dados Geográficos e Logísticos
| Entregável | Descrição | Status |
|---|---|---|
| Mapa de bairros Cuiabá | Todos os bairros de Cuiabá com suas conexões diretas, vias principais e distâncias médias | ✅ Concluído |
| Mapa de bairros Várzea Grande | Bairros de VG com conexões diretas, via das pontes e articulação metropolitana | ✅ Concluído |
| Corredores Logísticos | 3 corredores de entrega traçados com tempo estimado, distância e vantagens operacionais | ✅ Concluído |
| Cadastro por bairro (ligações) | Matriz de grafo viário conectando bairros vizinhos para roteirização realista | ✅ Concluído |

#### 🏃 Sprints do MVP Executadas
| Sprint | Entregável Principal | Status |
|---|---|---|
| **Sprint 0** | Ideação, PRD (`dor.md`), arquitetura (`contexto.md`) e protótipo funcional (`index.html`) | ✅ Concluída |
| **Sprint 1** | Schema de dados, CRUD de clientes/pedidos/entregadores, camada de persistência LocalStorage | ✅ Concluída |
| **Sprint 2** | Motor de roteirização (Nearest Neighbor + EDF), monitor de SLA e classificação de prazos | ✅ Concluída |
| **Sprint 3** | Dashboard administrativo com mapa Canvas, KPIs, filtros, simulador de rota e modal de pedidos | ✅ Concluída |
| **Sprint 4** | Interface mobile-first do motoboy com "Marcar como Entregue", Waze/Maps e registro de ocorrências | ✅ Concluída |
| **Sprint 5** | Sincronização bidirecional (BroadcastChannel + Storage Events) e operação 100% offline | ✅ Concluída |
| **Sprint 6** | Suíte de testes automatizados in-browser (6 baterias QA) e script de servidor local PowerShell | ✅ Concluída |

---

### 5.2. 🔴 O QUE FALTA FAZER (Pendências e Próximas Fases)

#### 🗄️ Dados Reais (Alta Prioridade)
| Pendência | Descrição | Prioridade |
|---|---|---|
| **Extrair dados dos CSVs de Cuiabá e VG** | Os arquivos [`cuiaba_denominacoes_logradouros.csv`](file:///c:/Users/admin/Documents/monitormentoboy/cuiaba_denominacoes_logradouros.csv) e [`varzea_grande_anexo1_completo.csv`](file:///c:/Users/admin/Documents/monitormentoboy/varzea_grande_anexo1_completo.csv) foram processados para extrair logradouros, bairros e endereços operacionais reais | ✅ Concluído |
| **Criar arquivo de banco de dados (`db.json`)** | Arquivo estruturado com 15 distritos, 37 clientes e 37 entregas com dados reais de Cuiabá e Várzea Grande | ✅ Concluído |
| **Integrar dados reais no `index.html`** | Substituído os dados de seed fictícios pelos endereços e clientes reais extraídos dos CSVs, com carregamento assíncrono via `db.json` | ✅ Concluído |

#### 🗺️ Mapa Real (Alta Prioridade)
| Pendência | Descrição | Prioridade |
|---|---|---|
| **Integrar Leaflet.js + OpenStreetMap** | Leaflet.js integrado ao `index.html` com mapa base CartoDB Dark (OpenStreetMap), alternância Canvas ↔ Leaflet, marcadores de distritos e entregas coloridos por SLA, popup com dados da entrega, linha destacada do corredor ativo | ✅ Concluído |
| **Geocodificar endereços reais** | Coordenadas lat/lng definidas para todos os 15 distritos baseadas nos dados geográficos reais de Cuiabá/VG | ✅ Concluído |
| **Limites oficiais dos municípios** | Camada GeoJSON dos limites de Cuiabá e Várzea Grande integrada ao mapa Leaflet (via `cuiaba_vg_municipios.json`, origem: repositório `tbrugz/geodata-br`, dados IBGE 2020) | ✅ Concluído |
| **Plotar rotas reais no mapa** | Integrar OSRM (Open Source Routing Machine) para traçar rotas reais pelas ruas, não apenas linhas retas | 🟡 Média |

#### 📱 Funcionalidades Complementares (Média Prioridade)
| Pendência | Descrição | Prioridade |
|---|---|---|
| **Autenticação de usuários** | Login separado para Administrador e Motoboy com controle de acesso básico | 🟡 Média |
| **Histórico de entregas** | Tela de relatório com filtros por data, entregador e bairro mostrando o histórico de rotas concluídas | 🟡 Média |
| **Exportação de dados** | Botão para exportar relatório diário de entregas em PDF ou CSV | 🟡 Média |
| **Push Notifications** | Notificação no celular do motoboy quando um novo pedido for atribuído à sua rota | 🟡 Média |

#### 🔧 Infraestrutura e Escala (Baixa Prioridade / Pós-MVP)
| Pendência | Descrição | Prioridade |
|---|---|---|
| **Backend REST API** | Migrar a lógica de negócio para um servidor Node.js ou Python (FastAPI/Flask) com banco de dados real (PostgreSQL/SQLite) | 🟢 Baixa |
| **Banco de dados persistente** | Substituir o LocalStorage por um banco real para persistência cross-device e suporte a múltiplos usuários simultâneos | 🟢 Baixa |
| **Sincronização via WebSocket** | Substituir BroadcastChannel por WebSocket para sincronização em tempo real entre dispositivos diferentes (não apenas abas do mesmo navegador) | 🟢 Baixa |
| **PWA (Progressive Web App)** | Adicionar Service Worker e Manifest para instalação no celular como aplicativo nativo | 🟢 Baixa |
| **Deploy em produção** | Publicar em GitHub Pages (versão offline) ou VPS (versão com backend) | 🟢 Baixa |

---

### 5.3. 📊 Resumo Executivo de Progresso

```
FASE 1 — DOCUMENTAÇÃO E ESPECIFICAÇÃO  ████████████████████ 100% ✅
FASE 2 — MVP OFFLINE (index.html)       ████████████████████ 100% ✅
FASE 3 — DADOS GEOGRÁFICOS CUIABÁ/VG   ████████████████████ 100% ✅
           (rotas e bairros ✅ | dados reais dos CSVs ✅ | db.json ✅)
FASE 4 — MAPA REAL (Leaflet + OSM)      ████████████████████  90% 🔄
           (Leaflet integrado ✅ | Limites municípios IBGE ✅ | OSRM rotas reais ❌)
FASE 5 — AUTENTICAÇÃO E HISTÓRICO       ░░░░░░░░░░░░░░░░░░░░   0% 🔴
FASE 6 — BACKEND E INFRAESTRUTURA       ░░░░░░░░░░░░░░░░░░░░   0% 🔴
```

> **🎯 Próximos Passos Recomendados (em ordem de impacto):**
> 1. **Integrar OSRM** para traçar rotas reais pelas ruas no mapa Leaflet (substituir linhas retas por trajetos viários reais).
> 2. **Implementar backend** Node.js/Python para suporte multi-dispositivo (substituir LocalStorage por banco real).
> 3. **Autenticação de usuários** (Admin vs. Motoboy) e histórico de entregas.
> 4. **Exportação de dados** (PDF/CSV) e PWA (Service Worker + Manifest).
