class RoleSerializer
  include JSONAPI::Serializer
  set_type :role

  attributes :name, :code, :description, :is_system, :can_assign_permissions, :is_active

  has_many :permissions, serializer: PermissionSerializer
end
