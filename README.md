# TaskMaster (Gerenciador de Tarefas)

[![Ruby](https://img.shields.io/badge/Ruby-3.x-red.svg)](https://www.ruby-lang.org/)
[![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-8.x-cc0000.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791.svg)](https://www.postgresql.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)

Projeto pessoal de portfólio focado no desenvolvimento Fullstack.

**Acesso em Produção:** [Task Master](https://rails-task-manager-4z2r.onrender.com)

## 1. Objetivo
Desenvolver uma aplicação monolítica robusta para o gerenciamento de tarefas e categorias diárias. O sistema conta com autenticação de usuários, segregação de acesso baseada em papéis (Usuário Padrão vs. Administrador) e uma interface responsiva, atuando como uma ferramenta completa de produtividade.

## 2. Escopo Funcional

### 2.1. Funcionalidades do Usuário Padrão
* Criar conta, realizar login (Autenticação).
* Criar, editar, visualizar e excluir categorias personalizadas.
* Adicionar tarefas às categorias com prazos de vencimento.
* Alterar o status das tarefas de forma dinâmica (Pendente, Em Progresso, Concluída).
* Filtrar tarefas por status em tempo real no Dashboard.

### 2.2. Funcionalidades do Administrador (Painel Admin)
* Acesso a um painel de controle exclusivo e protegido.
* Gerenciamento global de usuários (CRUD completo de contas).
* Capacidade de conceder ou revogar privilégios administrativos de outros usuários.
* Visão global no Dashboard (capacidade de ver a autoria de categorias e tarefas de toda a base de usuários).

## 3. Arquitetura e Decisões de Design

A arquitetura deste projeto foi guiada pelo padrão **MVC (Model-View-Controller)** nativo do ecossistema Rails, aplicando princípios de Baixo Acoplamento e Segurança.

### 3.1. Estrutura de Camadas e Segurança

* **`Controller`**: Recebe as requisições HTTP e delega as ações. Foi implementado um namespace isolado (`/admin`) para garantir que controladores administrativos herdem configurações restritas de segurança.
* **`View`**: Construída utilizando as convenções do Rails (ERB) em conjunto com o Tailwind CSS para uma UI/UX moderna. A filtragem de dados no Dashboard é feita em memória (`.select`) para evitar queries no banco de dados.
* **`Model`**: Concentra a lógica de relacionamento do banco de dados relacional (`User has_many Categories`, `Category has_many Tasks`).
* **Segurança (Autenticação e Autorização):** * O controle de identidade é gerenciado pela biblioteca **Devise** (criptografia de senhas com Bcrypt). 
    * A autorização de acessos e bloqueio de recursos (garantir que o usuário A não veja ou apague as tarefas do usuário B) é garantida pelas políticas da gem **Pundit**.

## 4. Tecnologias Utilizadas

* **Linguagem:** Ruby 3.x
* **Framework:** Ruby on Rails 8.x
* **Banco de Dados:** PostgreSQL
* **Front-end:** Tailwind CSS, HTML5, ERB
* **Principais Gems:** `devise` (Autenticação), `pundit` (Autorização)
* **Hospedagem/DevOps:** Render (Deploy contínuo, variáveis de ambiente seguras e compilação via Nixpacks).

## 5. Principais Mapeamentos de Rotas

* **Dashboard Principal:** `GET /` (Requer Login)
* **Gerenciamento de Categorias:** `GET, POST, PUT, DELETE /categories`
* **Gerenciamento de Tarefas:** `GET, POST, PUT, DELETE /tasks`
* **Painel Administrativo:** `GET /admin/users` (Protegido por Pundit - Somente Admins)