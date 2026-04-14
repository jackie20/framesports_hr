module ApiResponse
  def render_success(data, status: :ok, meta: {}, links: {})
    response_body = { data: data }
    response_body[:meta]  = meta.merge(timestamp: Time.current.iso8601)  if meta.present?
    response_body[:links] = links if links.present?
    render json: response_body, status: status
  end

  def render_collection(serialized_data, status: :ok)
    render json: {
      data:  serialized_data,
      meta:  pagination_meta.merge(timestamp: Time.current.iso8601),
      links: pagination_links
    }, status: status
  end

  def render_created(data)
    render_success(data, status: :created, meta: { timestamp: Time.current.iso8601 })
  end

  def render_no_content
    head :no_content
  end

  def error_response(title, detail, status: nil, code: nil)
    {
      errors: [{
        status: status.to_s,
        code:   code || title.upcase.tr(" ", "_"),
        title:  title,
        detail: detail
      }]
    }
  end

  def render_errors(errors, status: :unprocessable_entity)
    render json: {
      errors: errors.map do |attr, messages|
        {
          status: status.to_s,
          code:   "VALIDATION_ERROR",
          title:  "Validation Failed",
          detail: messages.is_a?(Array) ? messages.join(", ") : messages,
          source: { pointer: "/data/attributes/#{attr}" }
        }
      end
    }, status: status
  end

  def render_record_errors(record, status: :unprocessable_entity)
    render_errors(record.errors.messages, status: status)
  end
end
