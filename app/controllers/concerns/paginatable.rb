module Paginatable
  include Pagy::Backend

  def paginate(scope)
    @pagy, records = pagy(scope, items: per_page)
    records
  end

  def pagination_meta
    return {} unless @pagy

    {
      total_count: @pagy.count,
      page:        @pagy.page,
      per_page:    @pagy.items,
      total_pages: @pagy.pages
    }
  end

  def pagination_links
    return {} unless @pagy

    base = request.base_url + request.path
    links = { self: "#{base}?page=#{@pagy.page}" }
    links[:next] = "#{base}?page=#{@pagy.next}" if @pagy.next
    links[:prev] = "#{base}?page=#{@pagy.prev}" if @pagy.prev
    links[:last] = "#{base}?page=#{@pagy.last}"
    links
  end

  private

  def per_page
    [params.fetch(:per_page, 25).to_i, 100].min
  end
end
