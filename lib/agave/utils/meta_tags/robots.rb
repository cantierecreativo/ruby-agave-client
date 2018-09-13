# frozen_string_literal: true
require 'agave/utils/meta_tags/base'

module Agave
  module Utils
    module MetaTags
      class Robots < Base
        def build
          meta_tag('robots', 'noindex') if site.no_index
        end
      end
    end
  end
end
