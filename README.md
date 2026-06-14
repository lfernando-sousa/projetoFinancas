# Projeto Financas

Sistema de finanças pessoais composto por um banco de dados Oracle rodando em container Docker e uma API REST em Python/FastAPI.

## Motivação

O objetivo do projeto é a criação de um programa de controle financeiro inspirado no app *Minhas Finanças*.
Para o desenvovimento serão inicialmente utilizados tecnologias como Docker, Oracle Database e Python o desenvolvimento e implementação das funcionalidas do sistema será feito por etapas.

## Etapa 1: Criação do Banco de dados e usuários

- **Estrutura de arquivos**

  ~~~text
   database/               # Banco de dados Oracle
  ├── docker-compose.yml   # Compose individual do banco
  └── scripts/             # Scripts de criação dos objetos no banco
  ~~~

### 1.1 Executar `docker-compose.yml`

- `docker-compose.yml`

  ~~~bash
  # Navegar até o diretório onde está o arquivo
  docker compose up -d # Para executar a imagem
  docker compose down -v # Derruba tudo e limpa os volumes
  ~~~

### 1.1 Executar arquivos .bat  da pasta `scripts/`

- Na pasta estáo os scripts necessários para a criação da estrutura do banco: usuários, tabelas, packages, etc.
- Para facilitar a configuração da base foram criadas arquivo .bat que percorrem o conteudo da pasta scripts e fazem a execução no docker *basta executar os bat na ordem numérica: 001, 002*

---
