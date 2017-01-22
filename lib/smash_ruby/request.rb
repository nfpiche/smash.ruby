require 'faraday'
require 'dry-monads'

module SmashRuby
  module Request
    M = Dry::Monads

    def self.get(url, slug, type)
      response = Faraday.get(url)

      if response.success?
        M.Right(JSON.parse(response.body))
      else
        M.Left(SmashRuby::Errors::ErrorHandler.build_error(
          type,
          slug,
          response.status
        ))
      end
    end
  end
end
