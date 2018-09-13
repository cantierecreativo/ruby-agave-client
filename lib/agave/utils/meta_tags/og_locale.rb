# frozen_string_literal: true
require 'agave/utils/meta_tags/base'

module Agave
  module Utils
    module MetaTags
      class OgLocale < Base
        def build
          locale = I18n.locale
          og_tag('og:locale', "#{locale}_#{locale.upcase}")
        end
      end
    end
  end
end
