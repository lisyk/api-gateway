# frozen_string_literal: true

class FaradayMock
  def initialize(id)
    @id = id
  end

  def get
    Rack::MockResponse.new(200, {}, [{ 'id' => @id }].to_json)
  end
end
