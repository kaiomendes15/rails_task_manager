require 'rails_helper'

RSpec.describe Category, type: :model do

  # precisa criar um usuario pq o banco de teste sempre é zerado.
  let(:test_user) { User.create!(email: "teste_user@email.com", password: "password123") }
  
  context "Quanto os atributos obrigatórios estão preenchidos" do
    it "é válido" do

      category = Category.new(title: "Trabalho", description: "Tarefas relacionadas ao trabalho", user: test_user)

      category.valid? 
      
      expect(category).to be_valid
    end 
  end

  context "Quando os atributos obrigatórios não estão preenchidos" do
    it "não é válido" do
      category = Category.new(title: "", description: "", user: test_user)
      category.valid? # evitar lazy evaluation
      # o active record cria a categoria, mas ele nao valida se tudo esta correto, entao ele nao gera o category.errors[...], entao precisa chamar o valid? para gerar os erros de validacao
      expect(category.errors[:title]).to include("can't be blank")
      expect(category.errors[:description]).to include("can't be blank")
    end
  end

  context "Quando o título está em branco" do
    it "não é válido" do
      category = Category.new(title: "", description: "Tarefas relacionadas ao trabalho", user: test_user)

      category.valid?
      expect(category.errors[:title]).to include("can't be blank")
    end
  end

  context "Quando a descrição está em branco" do
    it "não é válido" do
      category = Category.new(title: "Trabalho", description: "", user: test_user)

      category.valid?
      expect(category.errors[:description]).to include("can't be blank")
    end
  end
end
