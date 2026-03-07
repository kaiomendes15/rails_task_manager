#!/usr/bin/env bash
# Interrompe a execução se ocorrer algum erro
set -o errexit

echo "📦 Instalando dependências..."
bundle install

echo "🎨 Compilando Tailwind CSS e Assets..."
bundle exec rails assets:precompile
bundle exec rails assets:clean

echo "🗄️ Executando migrações do banco de dados..."
bundle exec rails db:migrate