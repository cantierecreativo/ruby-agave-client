# frozen_string_literal: true
require 'agave/utils/meta_tags/base'

module Agave
  module Utils
    module MetaTags
      class Image < Base
        def build
          return unless image

          [
            og_tag('og:image', image.url),
            card_tag('twitter:image', image.url)
          ]
        end

        def image
          @image ||= seo_field_with_fallback(:image, item_image)
        end

        def item_image
          item && item.fields
                      .select { |field| field.field_type == 'image' }
                      .map { |field| item.send(field.api_key) }
                      .compact
                      .find do |image|

                        image.width && image.height &&
                          image.width >= 200 && image.height >= 200
                      end
        end
      end
    end
  end
end
