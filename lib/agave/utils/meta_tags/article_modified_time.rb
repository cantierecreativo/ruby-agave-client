# frozen_string_literal: true
require 'agave/utils/meta_tags/base'
require 'time'

module Agave
  module Utils
    module MetaTags
      class ArticleModifiedTime < Base
        def build
          og_tag('article:modified_time', item.updated_at.iso8601) if item
        end
      end
    end
  end
end
