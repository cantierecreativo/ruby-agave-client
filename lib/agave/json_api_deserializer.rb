# frozen_string_literal: true
module Agave
  class JsonApiDeserializer
    def deserialize(data)
      data = data[:data]

      if data.is_a? Array
        data.map { |resource| deserialize_resource(resource) }
      else
        deserialize_resource(data)
      end
    end

    def deserialize_resource(data)
      result = { id: data[:id] }

      if data[:attributes]
        result.merge!(data[:attributes])
      end

      relationships = data.delete(:relationships)

      if relationships
        relationships.each do |key, handle|
          handle_data = handle['data']
          value = if handle_data.is_a? Array
                    handle_data.map { |ref| ref['id'] }
                  elsif handle_data.is_a? Hash
                    handle_data[:id]
                  end
          result[key] = value
        end
      end

      result.with_indifferent_access
    end
  end
end
