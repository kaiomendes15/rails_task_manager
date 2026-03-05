require 'rails_helper'

RSpec.describe TaskPolicy, type: :policy do
  let(:test_user) { User.create!(email: "test_user@email.com", password: "password123") }
  let(:test_user2) { User.create!(email: "test_user2@email.com", password: "password123") }
  let(:test_admin) { User.create!(email: "test_admin@email.com", password: "password123", is_admin: true) }
  let(:category) { Category.create!(title: "Test Category", description: "Test description", user: test_user) }
  let(:category2) { Category.create!(title: "Test Category 2", description: "Test description 2", user: test_user2) }
  let(:task) { Task.create!(title: "Test Task", due_date: Date.tomorrow, user: test_user, category: category) }
  let(:task2) { Task.create!(title: "Test Task 2", due_date: Date.tomorrow, user: test_user2, category: category2) }

  subject { described_class }

  permissions ".scope" do
    it "permite acesso apenas às tasks do usuário" do
      resultado = TaskPolicy::Scope.new(test_user, Task).resolve

      expect(resultado).to include(task)
      expect(resultado).not_to include(task2)
    end

    it "permite acesso a todas as tasks para um usuário admin" do
      resultado = TaskPolicy::Scope.new(test_admin, Task).resolve

      expect(resultado).to include(task)
      expect(resultado).to include(task2)
    end
  end

  permissions :show? do
    it "permite acesso se o usuário for o dono da task" do
      expect(subject).to permit(test_user, task)
    end
    it "bloqueia o acesso se o usuário for um invasor (não for o dono)" do
      expect(subject).not_to permit(test_user2, task)
    end
    it "permite o acesso de qualquer task se o usuário for admin" do
      expect(subject).to permit(test_admin, task)
    end
  end

  permissions :create? do
    it "permite a criação de tasks para qualquer usuário" do
      expect(subject).to permit(test_user, Task.new)
      expect(subject).to permit(test_admin, Task.new)
    end
  end

  permissions :update? do
    it "permite a atualização se o usuário for o dono da task" do
      expect(subject).to permit(test_user, task)
    end

    it "bloqueia a atualização se o usuário for um invasor (não for o dono)" do
      expect(subject).not_to permit(test_user2, task)
    end

    it "permite a atualização de qualquer task se o usuário for admin" do
      expect(subject).to permit(test_admin, task)
    end
  end

  permissions :destroy? do
    it "permite a exclusão se o usuário for o dono da task" do
      expect(subject).to permit(test_user, task)
    end

    it "bloqueia a exclusão se o usuário não for o dono" do
      expect(subject).not_to permit(test_user2, task)
    end

    it "permite a exclusão de qualquer task se o usuário for admin" do
      expect(subject).to permit(test_admin, task)
    end
  end
end
