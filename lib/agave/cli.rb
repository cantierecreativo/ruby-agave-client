# frozen_string_literal: true
require 'thor'
require 'agave/dump/runner'
require 'agave/dump/ssg_detector'
require 'agave/watch/site_change_watcher'
require 'listen'
require 'thread'

module Agave
  class Cli < Thor
    package_name 'AgaveCMS'

    desc 'dump', 'dumps AgaveCMS content into local files'
    option :config, default: 'agave.config.rb'
    option :token, default: ENV['AGAVE_API_TOKEN'], required: true
    option :preview, default: false, type: :boolean
    option :watch, default: false, type: :boolean
    def dump
      if !ENV['AGAVE_API_TOKEN']
        say 'Site token is not specified! Please configure AGAVE_API_TOKEN.'
        exit 0
      end
      
      config_file = File.expand_path(options[:config])
      watch_mode = options[:watch]
      preview_mode = options[:preview]

      client = Agave::Site::Client.new(
        extra_headers: {
          'X-Reason' => 'dump',
          'X-SSG' => Dump::SsgDetector.new(Dir.pwd).detect
        }
      )

      if watch_mode
        site_id = client.request(:get, '/api/site')['data']['id']

        semaphore = Mutex.new

        thread_safe_dump(semaphore, config_file, client, preview_mode)

        Agave::Watch::SiteChangeWatcher.new(site_id).connect do
          thread_safe_dump(semaphore, config_file, client, preview_mode)
        end

        watch_config_file(config_file) do
          thread_safe_dump(semaphore, config_file, client, preview_mode)
        end

        sleep
      else
        Dump::Runner.new(config_file, client, preview_mode).run
      end
    end

    desc 'check', 'checks the presence of a AgaveCMS token'
    def check
      exit 0 if ENV['AGAVE_API_TOKEN']

      say 'Site token is not specified!'
      token = ask "Please paste your AgaveCMS site read-only API token:\n>"

      if !token || token.empty?
        puts 'Missing token'
        exit 1
      end

      File.open('.env', 'a') do |file|
        file.puts "AGAVE_API_TOKEN=#{token}"
      end

      say 'Token added to .env file.'

      exit 0
    end

    no_tasks do
      def watch_config_file(config_file, &block)
        Listen.to(
          File.dirname(config_file),
          only: /#{Regexp.quote(File.basename(config_file))}/,
          &block
        ).start
      end

      def thread_safe_dump(semaphore, config_file, client, preview_mode)
        semaphore.synchronize do
          Dump::Runner.new(config_file, client, preview_mode).run
        end
      end
    end
  end
end
