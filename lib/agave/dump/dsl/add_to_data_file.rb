# frozen_string_literal: true
require 'agave/dump/operation/add_to_data_file'

module Agave
  module Dump
    module Dsl
      module AddToDataFile
        def add_to_data_file(*args)
          operations.add Operation::AddToDataFile.new(operations, *args)
        end
      end
    end
  end
end
