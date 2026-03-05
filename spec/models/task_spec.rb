require 'rails_helper'

RSpec.describe Task, type: :model do
  # precisa criar um usuario pq o banco de teste sempre é zerado.
  let(:test_user) { User.create!(email: "test_user@email.com", password: "password123") }
  let(:test_category) { Category.create!(title: "Trabalho", description: "Tarefas relacionadas ao trabalho", user: test_user) }
  let(:test_user2) { User.create!(email: "test_user2@email.com", password: "password123") }
  let(:other_category) { Category.create!(title: "Lazer", description: "Tarefas relacionadas ao lazer", user: test_user2) }

  context "Quando os atributos obrigatórios estão preenchidos" do
    it "é válido" do
      task = Task.new(title: "Trabalho", due_date: Date.tomorrow, category: test_category, user: test_user)

      task.valid?

      expect(task).to be_valid
    end
  end

  context "Quando os atributos obrigatórios não estão preenchidos" do
    it "não é válido" do
      task = Task.new(title: "", due_date: "", category: nil, user: test_user)
      task.valid? # evitar lazy evaluation
      # o active record cria a tarefa, mas ele nao valida se tudo esta correto, entao ele nao gera o task.errors[...], entao precisa chamar o valid? para gerar os erros de validacao
      expect(task.errors[:title]).to include("can't be blank")
      expect(task.errors[:due_date]).to include("can't be blank")
      expect(task.errors[:category_id]).to include("can't be blank")
    end
  end

  context "Quando o título está em branco" do
    it "não é válido" do
      task = Task.new(title: "", due_date: Date.tomorrow, category: test_category, user: test_user)

      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end
  end

  context "Quando a due_date está em branco" do
    it "não é válido" do
      task = Task.new(title: "Trabalho", due_date: "", category: test_category, user: test_user)

      task.valid?
      expect(task.errors[:due_date]).to include("can't be blank")
    end
  end

  context "Quando a category_id está em branco" do
    it "não é válido" do
      task = Task.new(title: "Trabalho", due_date: Date.tomorrow, category: nil, user: test_user)

      task.valid?
      expect(task.errors[:category_id]).to include("can't be blank")
    end
  end

  context "Quando a due_date está no passado" do
    it "não é válido" do
      task = Task.new(title: "Trabalho", due_date: Date.yesterday, category: test_category, user: test_user)

      task.valid?
      expect(task.errors[:due_date]).to include("A data de vencimento não pode ser no passado.")
    end
  end

  context "Status inicial igual a pendente" do
    it "é válido" do
      task = Task.new(title: "Trabalho", due_date: Date.tomorrow, category: test_category, user: test_user)

      task.valid?

      expect(task.status).to eq("pendente")
    end
  end

  context "Alterar status da tarefa" do
    it "atualiza o status com sucesso" do
      # ! -> lanca excecao se tiver erro.
      task = Task.create!(title: "Trabalho", due_date: Date.tomorrow, category: test_category, user: test_user)
      expect(task.status).to eq("pendente")

      # enum tem um metodo que altera o seu valor e ja da update
      task.em_progresso!
      # task.update(status: :em_progresso)

      expect(task.status).to eq("em_progresso")
    end
  end

  context "Quando a categoria pertence a outro usuário" do
    it "não é válido" do
      # Tentar criar uma tarefa para o test_user usando a categoria do test_user2
      task = Task.new(title: "Tarefa inválida", due_date: Date.tomorrow, category: other_category, user: test_user)

      task.valid?
      expect(task.errors[:category_id]).to include("Essa categoria não pertence ao usuário.")
    end
  end
end
