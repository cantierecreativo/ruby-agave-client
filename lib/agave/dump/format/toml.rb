# frozen_string_literal: true
require 'active_support/core_ext/hash/keys'
require 'toml'

class Time
  def to_toml(_path = '')
    utc.strftime('%Y-%m-%dT%H:%M:%SZ')
  end
end

class Date
  def to_toml(_path = '')
    strftime('%Y-%m-%d')
  end
end

module Agave
  module Dump
    module Format
      module Toml
        def self.dump(value)
          TOML::Generator.new(value).body
        end

        def self.frontmatter_dump(value)
          "+++\n#{dump(value)}+++"
        end
      end
    end
  end
end
