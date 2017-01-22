module SmashRuby
  module Errors
    module ErrorHandler
      def self.build_error(model, request, status)
        if status == 404
          Errors::NotFoundError.new(model, request)
        else
          Errors::UnknownError.new(model, request)
        end
      end
    end
  end
end
