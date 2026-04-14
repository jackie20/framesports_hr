class SharedFileSerializer
  include JSONAPI::Serializer
  set_type :shared_file

  attributes :title, :description, :file_path, :file_name, :content_type, :file_size,
             :visibility, :version, :is_active, :created_at

  attribute :category do |obj|
    obj.file_category_lookup ? { id: obj.file_category_lookup.id, code: obj.file_category_lookup.code, value: obj.file_category_lookup.value } : nil
  end

  attribute :uploaded_by do |obj|
    obj.uploaded_by ? { id: obj.uploaded_by.id, full_name: obj.uploaded_by.full_name } : nil
  end
end
