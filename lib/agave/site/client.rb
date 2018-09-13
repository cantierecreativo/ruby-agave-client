# frozen_string_literal: true
require 'agave/api_client'
require 'agave/upload/file'
require 'agave/upload/image'

module Agave
  module Site
    class Client
      include ApiClient

      json_schema 'site-api'

      def upload_file(path_or_url)
        file = Upload::File.new(self, path_or_url)
        file.upload
      end

      def upload_image(path_or_url)
        file = Upload::Image.new(self, path_or_url)
        file.upload
      end
    end
  end
end
