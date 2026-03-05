class Category < ApplicationRecord
  validates :title, :description, presence: true
  belongs_to :user

  belongs_to :user

  has_many :tasks, dependent: :destroy
end
