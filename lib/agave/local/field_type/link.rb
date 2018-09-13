# frozen_string_literal: true
module Agave
  module Local
    module FieldType
      class Link
        def self.parse(value, repo)
          value && repo.find(value)
        end
      end
    end
  end
end
