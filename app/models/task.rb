class Task < ApplicationRecord
  validates :title, :due_date, :category_id, presence: true
  belongs_to :category
  belongs_to :user

  enum :status, pendente: 0, em_progresso: 1, concluida: 2, default: :pendente

  validate :category_must_belong_to_user
  validate :due_date_cannot_be_in_the_past

  private

  def category_must_belong_to_user
     if category.present? && category.user_id != user.id
       errors.add(:category_id, "Essa categoria não pertence ao usuário.")
     end
  end

  def due_date_cannot_be_in_the_past
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "A data de vencimento não pode ser no passado.")
    end
  end
end
