class LookupValue < ApplicationRecord
  belongs_to :lookup_type

  validates :code,  presence: true,
            uniqueness: { scope: :lookup_type_id, case_sensitive: false }
  validates :value, presence: true

  before_save :downcase_code

  scope :active,  -> { where(is_active: true) }
  scope :ordered, -> { order(:sort_order, :value) }

  def meta
    return {} if meta_json.blank?
    JSON.parse(meta_json)
  rescue JSON::ParseError
    {}
  end

  private

  def downcase_code
    self.code = code.downcase.strip if code.present?
  end
end
