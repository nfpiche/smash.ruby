require 'json'

module SmashRuby
  module Errors
    class NotFoundError
      attr_reader :model, :request

      def initialize(model, request)
        @model = model.model_name
        @request = request
      end

      def to_json
        {
          model: @model,
          error: "Not found with request: #{@request}"
        }.to_json
      end
    end
  end
end
