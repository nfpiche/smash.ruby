require 'json'

module SmashRuby
  module Errors
    class NotFoundError
      attr_reader :model, :request

      def initialize(model, request)
        @model = model
        @request = request
      end

      def to_json
        {
          model: @model,
          status: 404,
          error: "Not found with request: #{@request}"
        }.to_json
      end
    end
  end
end
