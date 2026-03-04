class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

  enum :status, pendente: 0, em_progresso: 1, concluida: 2, default: :pendente

  validate :category_must_belong_to_user

  private

  def category_must_belong_to_user
     if category.present? && category.user_id != user.id
       errors.add(:category_id, "Essa categoria não pertence ao usuário.")
     end
  end

  
end
