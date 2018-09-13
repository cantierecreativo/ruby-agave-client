require 'faraday'
require 'faraday_middleware'
require 'json'
require 'json_schema'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/inflector'

require 'agave/version'
require 'agave/repo'

require 'agave/api_error'

require 'cacert'

module Agave
  module ApiClient
    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        attr_reader :token, :base_url, :schema, :extra_headers
      end
    end

    module ClassMethods
      def json_schema(subdomain)
        define_method(:initialize) do |options = {}|
          @token = ENV['AGAVE_API_TOKEN']
          @base_url = options[:base_url] || ENV["AGAVECMS_BASE_URL"]
          @extra_headers = options[:extra_headers] || {}
        end

        response = Faraday.get(
          "#{ENV["AGAVECMS_BASE_URL"]}/docs/site-api-hyperschema.json"
        )

        schema = JsonSchema.parse!(JSON.parse(response.body))
        schema.expand_references!

        schema.definitions.each do |type, schema|
          is_collection = schema.links.select{|x| x.rel === "instances"}.any?
          namespace = is_collection ? type.pluralize : type

          define_method(namespace) do
            instance_variable_set(
              "@#{namespace}",
              instance_variable_get("@#{namespace}") ||
              Agave::Repo.new(self, type, schema)
            )
          end
        end
      end
    end

    def request(*args)
      connection.send(*args).body.with_indifferent_access
    rescue Faraday::SSLError => e
      raise e if ENV['SSL_CERT_FILE'] == Cacert.pem

      Cacert.set_in_env
      request(*args)
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      puts e.message
      raise e
    rescue Faraday::ClientError => e
      error = ApiError.new(e)
      puts '===='
      puts error.message
      puts '===='
      raise error
    end

    private

    def connection
      default_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@token}",
        'User-Agent' => "ruby-client v#{Agave::VERSION}",
        'X-Api-Version' => "2"
      }

      options = {
        url: base_url + "/api",
        headers: default_headers.merge(extra_headers)
      }
      @connection ||= Faraday.new(options) do |c|
        c.request :json
        c.response :json, content_type: /\bjson$/
        c.response :raise_error
        c.use FaradayMiddleware::FollowRedirects
        c.adapter :net_http
      end
    end
  end
end
