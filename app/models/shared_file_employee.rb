class SharedFileEmployee < ApplicationRecord
  belongs_to :shared_file
  belongs_to :employee

  validates :shared_file_id, uniqueness: { scope: :employee_id }
end
