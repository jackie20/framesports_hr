class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, :category, presence: true

  scope :by_category, ->(cat) { where(category: cat) }
  scope :ordered,     -> { order(:category, :code) }
end
