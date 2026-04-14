class PermissionSerializer
  include JSONAPI::Serializer
  set_type :permission

  attributes :code, :name, :category, :description, :is_system
end
