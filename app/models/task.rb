class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

  enum :status, { pendente: 0, em_progresso: 1, concluida: 2 }
end
