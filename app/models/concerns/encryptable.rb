module Encryptable
  extend ActiveSupport::Concern

  included do
    encrypts :national_id_number, deterministic: false
    encrypts :passport_number,    deterministic: false
    encrypts :tax_number,         deterministic: false
  end
end
