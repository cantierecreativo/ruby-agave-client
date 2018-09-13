# frozen_string_literal: true
require 'imgix'

module Agave
  module Local
    module FieldType
      class File
        attr_reader :path
        attr_reader :format
        attr_reader :size
        attr_reader :title
        attr_reader :alt
        attr_reader :image_host

        def self.parse(upload_attributes, repo)
          return nil if !upload_attributes
          return nil if !upload_attributes[:path]
          upload = repo.entities_repo.find_entity(
            "upload", upload_attributes[:path]
          )
          return nil if !upload
          new(
            upload.path,
            upload.format,
            upload.size,
            upload.alt,
            upload.title,
            repo.site.entity.image_host
          )
        end

        def initialize(path, format, size, alt, title, image_host)
          @path = path
          @format = format
          @size = size
          @image_host = image_host
          @alt = alt
          @title = title
        end

        def file
          Imgix::Client.new(
            host: image_host,
            secure: true,
            include_library_param: false
          ).path(path)
        end

        def url(opts = {})
          file.to_url(opts)
        end

        def to_hash(*_args)
          {
            format: format,
            size: size,
            alt: alt,
            title: title,
            url: url
          }
        end
      end
    end
  end
end
