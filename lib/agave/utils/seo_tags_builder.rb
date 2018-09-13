# frozen_string_literal: true
require 'agave/utils/meta_tags/title'
require 'agave/utils/meta_tags/description'
require 'agave/utils/meta_tags/image'
require 'agave/utils/meta_tags/robots'
require 'agave/utils/meta_tags/og_locale'
require 'agave/utils/meta_tags/og_type'
require 'agave/utils/meta_tags/og_site_name'
require 'agave/utils/meta_tags/article_modified_time'
require 'agave/utils/meta_tags/article_publisher'
require 'agave/utils/meta_tags/twitter_card'
require 'agave/utils/meta_tags/twitter_site'

module Agave
  module Utils
    class SeoTagsBuilder
      META_TAGS = [
        MetaTags::Title,
        MetaTags::Description,
        MetaTags::Image,
        MetaTags::Robots,
        MetaTags::OgLocale,
        MetaTags::OgType,
        MetaTags::OgSiteName,
        MetaTags::ArticleModifiedTime,
        MetaTags::ArticlePublisher,
        MetaTags::TwitterCard,
        MetaTags::TwitterSite
      ].freeze

      attr_reader :site, :item

      def initialize(item, site)
        @item = item
        @site = site
      end

      def meta_tags
        META_TAGS.map do |klass|
          klass.new(item, site).build
        end.flatten.compact
      end
    end
  end
end
