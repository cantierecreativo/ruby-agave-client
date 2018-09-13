# frozen_string_literal: true
module Agave
  class ApiError < StandardError
    attr_reader :faraday_error

    def initialize(faraday_error)
      @faraday_error = faraday_error
    end

    def message
      [
        'AgaveCMS API Error',
        "Status: #{faraday_error.response[:status]}",
        'Response:',
        JSON.pretty_generate(body)
      ].join("\n")
    end

    def body
      JSON.parse(faraday_error.response[:body])
    end
  end
end
