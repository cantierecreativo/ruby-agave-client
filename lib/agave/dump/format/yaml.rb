# frozen_string_literal: true
require 'active_support/core_ext/hash/keys'
require 'yaml'

require 'agave/local/item'

class Array
  def deep_stringify_keys
    each_with_object([]) do |value, accum|
      if value.is_a?(Hash) || value.is_a?(Array)
        new_val = value.deep_stringify_keys
        accum.push new_val
      else
        accum.push value
      end
      accum
    end
  end
end

module Agave
  module Dump
    module Format
      module Yaml
        def self.deep_hashify_items(value)
          case value
          when Array
            value.map { |v| deep_hashify_items(v) }
          when Hash
            value.each_with_object({}) do |(k, v), acc|
              acc[k] = deep_hashify_items(v)
            end
          when ::Agave::Local::Item
            value.to_hash
          else
            if value.respond_to?(:to_hash)
              value.to_hash
            else
              value
            end
          end
        end

        def self.dump(value)
          plain = deep_hashify_items(value)
          YAML.dump(plain.deep_stringify_keys).chomp.gsub(/^\-+\n/, '')
        end

        def self.frontmatter_dump(value)
          "---\n#{dump(value)}\n---"
        end
      end
    end
  end
end
