# frozen_string_literal: true
require 'agave/utils/meta_tags/base'

module Agave
  module Utils
    module MetaTags
      class TwitterCard < Base
        def build
          card_tag('twitter:card', 'summary')
        end
      end
    end
  end
end
