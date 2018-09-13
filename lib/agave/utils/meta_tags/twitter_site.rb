# frozen_string_literal: true
require 'agave/utils/meta_tags/base'

module Agave
  module Utils
    module MetaTags
      class TwitterSite < Base
        def build
          card_tag('twitter:site', twitter_account) if twitter_account
        end

        def twitter_account
          site.global_seo && site.global_seo.twitter_account
        end
      end
    end
  end
end
