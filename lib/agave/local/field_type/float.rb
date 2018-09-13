# frozen_string_literal: true
module Agave
  module Local
    module FieldType
      class Float
        def self.parse(value, _repo)
          value
        end
      end
    end
  end
end
