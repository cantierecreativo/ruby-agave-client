# frozen_string_literal: true
module Agave
  module Local
    module FieldType
      class Date
        def self.parse(value, _repo)
          value && ::Date.parse(value)
        end
      end
    end
  end
end
