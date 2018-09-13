# frozen_string_literal: true
module Agave
  module Local
    module FieldType
      class DateTime
        def self.parse(value, _repo)
          value && ::Time.parse(value).utc
        end
      end
    end
  end
end
