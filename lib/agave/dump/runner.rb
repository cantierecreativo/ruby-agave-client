# frozen_string_literal: true
require 'agave/dump/dsl/root'
require 'agave/dump/operation/root'
require 'agave/dump/ssg_detector'
require 'agave/local/loader'

module Agave
  module Dump
    class Runner
      attr_reader :config_path, :client, :destination_path, :preview_mode

      def initialize(config_path, client, preview_mode, destination_path = Dir.pwd)
        @config_path = config_path
        @preview_mode = preview_mode
        @client = client
        @destination_path = destination_path
      end

      def run
        print 'Fetching content from AgaveCMS... '

        loader.load

        I18n.available_locales = loader.items_repo.available_locales
        I18n.locale = I18n.available_locales.first

        Dsl::Root.new(
          File.read(config_path),
          loader.items_repo,
          operation
        )

        operation.perform

        puts "\e[32m✓\e[0m Done!"
      end

      def operation
        @operation ||= Operation::Root.new(destination_path)
      end

      def loader
        @loader ||= Agave::Local::Loader.new(client, preview_mode)
      end
    end
  end
end
