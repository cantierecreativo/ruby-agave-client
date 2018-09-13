# frozen_string_literal: true
require 'agave/dump/format/toml'
require 'agave/dump/format/yaml'

module Agave
  module Dump
    module Format
      def self.dump(format, value)
        converter_for(format).dump(value)
      end

      def self.frontmatter_dump(format, value)
        converter_for(format).frontmatter_dump(value)
      end

      def self.converter_for(format)
        case format.to_sym
        when :toml
          Format::Toml
        when :yaml, :yml
          Format::Yaml
        when :json
          Format::Json
        end
      end
    end
  end
end
