# frozen_string_literal: true
require 'agave/dump/dsl/directory'
require 'agave/dump/dsl/create_post'
require 'agave/dump/dsl/create_data_file'
require 'agave/dump/dsl/add_to_data_file'

require 'agave/dump/operation/directory'

module Agave
  module Dump
    module Dsl
      class Root
        include Dsl::CreateDataFile
        include Dsl::CreatePost
        include Dsl::AddToDataFile

        attr_reader :agave, :operations

        def initialize(config_code, agave, operations)
          @agave = agave
          @operations = operations

          # rubocop:disable Lint/Eval
          eval(config_code)
          # rubocop:enable Lint/Eval
        end

        def directory(path, &block)
          operation = Operation::Directory.new(operations, path)
          operations.add operation

          Directory.new(agave, operation, &block)
        end
      end
    end
  end
end
