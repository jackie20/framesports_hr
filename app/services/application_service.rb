class ApplicationService
  def self.call(...)
    new(...).call
  end

  private

  def success(data = nil)
    OpenStruct.new(success?: true, data: data, error: nil)
  end

  def failure(error, data = nil)
    OpenStruct.new(success?: false, data: data, error: error)
  end
end
