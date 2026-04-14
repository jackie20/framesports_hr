class DocumentSerializer
  include JSONAPI::Serializer
  set_type :employee_document

  attributes :title, :description, :file_path, :file_name, :content_type, :file_size,
             :issue_date, :expiry_date, :is_verified, :verified_at, :is_confidential, :created_at

  attribute :document_type do |obj|
    obj.document_type_lookup ? { id: obj.document_type_lookup.id, code: obj.document_type_lookup.code, value: obj.document_type_lookup.value } : nil
  end

  attribute :uploaded_by do |obj|
    obj.uploaded_by ? { id: obj.uploaded_by.id, name: obj.uploaded_by.full_name } : nil
  end
end
