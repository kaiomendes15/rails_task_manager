require 'rails_helper'

RSpec.describe CategoryPolicy, type: :policy do
  let(:test_user) { User.create!(email: "test_user@email.com", password: "password123") }
  let(:test_user2) { User.create!(email: "test_user2@email.com", password: "password123") }
  let(:test_admin) { User.create!(email: "test_admin@email.com", password: "password123", is_admin: true) }
  let(:category) { Category.create!(title: "Test Category", description: "Test description", user: test_user) }
  let(:category2) { Category.create!(title: "Test Category 2", description: "Test description 2", user: test_user2) }

  subject { described_class }

  permissions ".scope" do
    it "permite acesso apenas às categorias do usuário" do
      resultado = CategoryPolicy::Scope.new(test_user, Category).resolve

      expect(resultado).to include(category)
      expect(resultado).not_to include(category2)
    end
    
    it "permite acesso a todas as categorias para um usuário admin" do
      resultado = CategoryPolicy::Scope.new(test_admin, Category).resolve

      expect(resultado).to include(category)
      expect(resultado).to include(category2)
    end
    
  end

  permissions :show? do
    it "permite o acesso se o usuário for o dono da categoria" do
      expect(subject).to permit(test_user, category)
    end

    it "bloqueia o acesso se o usuário for um invasor (não for o dono)" do
      expect(subject).not_to permit(test_user2, category)
    end

    it "permite o acesso de qualquer categoria se o usuário for admin" do
      expect(subject).to permit(test_admin, category)
    end
  end

  permissions :create? do
    it "permite a criação de categorias para qualquer usuário" do
      expect(subject).to permit(test_user, Category.new)
      expect(subject).to permit(test_admin, Category.new)
    end
  end

  permissions :update? do
    it "permite a atualização se o usuário for o dono da categoria" do
      expect(subject).to permit(test_user, category)
    end

    it "bloqueia a atualização se o usuário for um invasor (não for o dono)" do
      expect(subject).not_to permit(test_user2, category)
    end

    it "permite a atualização de qualquer categoria se o usuário for admin" do
      expect(subject).to permit(test_admin, category)
    end
  end

  permissions :destroy? do
    it "permite a exclusão se o usuário for o dono da categoria" do
      expect(subject).to permit(test_user, category)
    end

    it "bloqueia a exclusão se o usuário não for o dono" do
      expect(subject).not_to permit(test_user2, category)
    end

    it "permite a exclusão de qualquer categoria se o usuário for admin" do
      expect(subject).to permit(test_admin, category)
    end
  end
end
