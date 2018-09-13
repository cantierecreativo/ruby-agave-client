# frozen_string_literal: true
require 'spec_helper'

module Agave
  module Utils
    describe FaviconTagsBuilder do
      include_context 'items repo'

      subject(:builder) { described_class.new(site, '#ff0000') }

      describe '#meta_tags' do
        context 'with no favicon' do
          let(:favicon) { nil }

          it 'returns an array of tags' do
            expect(builder.meta_tags).to eq [
              { tag_name: 'meta', attributes: { name: 'theme-color', content: '#ff0000' } },
              { tag_name: 'meta', attributes: { name: 'msapplication-TileColor', content: '#ff0000' } },
              { tag_name: 'meta', attributes: { name: 'application-name', content: 'XXX' } }
            ]
          end
        end

        context 'with favicon' do
          let(:favicon) {
            {
              path: '/favicon.png',
              format: 'jpg',
              size: 4000,
              width: 20,
              height: 20,
              alt: "an alt",
              title: "a title"
            }
          }

          it 'returns an array of tags' do
            expect(builder.meta_tags).to eq [
              { tag_name: 'meta', attributes: { name: 'theme-color', content: '#ff0000' } },
              { tag_name: 'meta', attributes: { name: 'msapplication-TileColor', content: '#ff0000' } },
              { tag_name: 'meta', attributes: { name: 'application-name', content: 'XXX' } }
            ]
          end
        end
      end
    end
  end
end
