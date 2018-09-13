# frozen_string_literal: true
require 'toml'
require 'json'
require 'yaml'

module Agave
  module Dump
    class SsgDetector
      attr_reader :path

      RUBY = %w(jekyll).freeze

      def initialize(path)
        @path = path
      end

      def detect
        ruby_generator ||
          'unknown'
      end

      private

      def ruby_generator
        gemfile_path = File.join(path, 'Gemfile')
        return unless File.exist?(gemfile_path)

        gemfile = File.read(gemfile_path)

        RUBY.find do |generator|
          gemfile =~ /('#{generator}'|"#{generator}")/
        end
      end
    end
  end
end
