# frozen_string_literal: true
require 'spec_helper'

module Agave
  module Local
    module FieldType
      RSpec.describe Agave::Local::FieldType::File do
        subject(:file) { described_class.parse(attributes, repo) }

        let(:repo) { instance_double('Agave::Local::ItemsRepo', site: site, entities_repo: entities_repo) }
        let(:site) { instance_double('Agave::Local::Site', entity: site_entity) }
        let(:site_entity) { double('Agave::Local::JsonApiEntity', image_host: 'foobar.com') }
        let(:entities_repo) { instance_double('Agave::Local::EntitiesRepo', find_entity: upload_entity) }
        let(:upload_entity) { double('Agave::Local::JsonApiEntity', attributes ) }

        let(:attributes) do
          {
            path: '/foo.png',
            format: 'jpg',
            size: 4000,
            width: 20,
            height: 20,
            alt: "an alt",
            title: "a title"
          }
        end

        it 'responds to path, format and size methods' do
          expect(file.path).to eq '/foo.png'
          expect(file.format).to eq 'jpg'
          expect(file.size).to eq 4000
        end

        it 'responds to url method' do
          expect(file.url(w: 300)).to eq 'https://foobar.com/foo.png?w=300'
        end
      end
    end
  end
end
