# frozen_string_literal: true
module Agave
  module Local
    module FieldType
      class Json
        def self.parse(value, _repo)
          value && JSON.parse(value)
        end
      end
    end
  end
end

