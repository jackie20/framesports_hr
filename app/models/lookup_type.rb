class LookupType < ApplicationRecord
  has_many :lookup_values, dependent: :destroy
  belongs_to :created_by, class_name: "Employee", optional: true

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  before_save :downcase_code

  scope :active,  -> { where(is_active: true) }
  scope :ordered, -> { order(:sort_order, :name) }

  def self.by_code(code)
    active.find_by!(code: code.to_s.downcase)
  end

  def self.values_for(type_code)
    by_code(type_code).lookup_values.active.ordered
  end

  private

  def downcase_code
    self.code = code.downcase.strip if code.present?
  end
end
