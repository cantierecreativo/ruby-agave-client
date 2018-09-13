# frozen_string_literal: true
require 'agave/dump/format'

module Agave
  module Dump
    module Operation
      class AddToDataFile
        attr_reader :context, :path, :format, :value

        def initialize(context, path, format, value)
          @context = context
          @path = path
          @format = format
          @value = value
        end

        def perform
          complete_path = File.join(context.path, path)
          FileUtils.mkdir_p(File.dirname(complete_path))

          content_to_add = Format.dump(format, value)

          old_content = if File.exist? complete_path
                          ::File.read(complete_path)
                        else
                          ''
                        end

          new_content = old_content.sub(
            /\n*(#\s*agavecms:start.*#\s*agavecms:end|\Z)/m,
            "\n\n# agavecms:start\n#{content_to_add}\n# agavecms:end"
          )

          File.open(complete_path, 'w') do |f|
            f.write new_content
          end
        end
      end
    end
  end
end
