# frozen_string_literal: true
require 'spec_helper'

module Agave
  module Local
    RSpec.describe Item do
      subject(:item) { described_class.new(entity, repo) }
      let(:entity) do
        double(
          'Agave::Local::JsonApiEntity(Item)',
          id: '14',
          item_type: item_type,
          title: 'My titlè with àccents',
          body: 'Hi there',
          position: 2,
          updated_at: '2010-01-01T00:00'
        )
      end
      let(:repo) do
        instance_double('Agave::Local::ItemsRepo')
      end
      let(:item_type) do
        double(
          'Agave::Local::JsonApiEntity(Content Type)',
          singleton: is_singleton,
          api_key: 'work_item',
          fields: fields
        )
      end
      let(:is_singleton) { false }
      let(:fields) do
        [
          double(
            'Agave::Local::JsonApiEntity(Field)',
            position: 1,
            api_key: 'title',
            localized: false,
            field_type: 'string',
            appeareance: { type: 'title' }
          ),
          double(
            'Agave::Local::JsonApiEntity(Field)',
            position: 1,
            api_key: 'body',
            localized: false,
            field_type: 'text',
            appeareance: { type: 'plain' }
          )
        ]
      end

      describe '#attributes' do
        it 'returns an hash of the field values' do
          expected_attributes = {
            'title' => 'My titlè with àccents',
            'body' => 'Hi there'
          }
          expect(item.attributes).to eq expected_attributes
        end
      end

      describe 'position' do
        it 'returns the entity position field' do
          expect(item.position).to eq 2
        end
      end

      describe 'updated_at' do
        it 'returns the entity updated_at field' do
          expect(item.updated_at).to be_a Time
        end
      end

      describe 'dynamic methods' do
        context 'existing field' do
          it 'returns the field value' do
            expect(item.respond_to?(:body)).to be_truthy
            expect(item.body).to eq 'Hi there'
          end

          context 'localized field' do
            let(:entity) do
              double(
                'Agave::Local::JsonApiEntity(Item)',
                id: '14',
                item_type: item_type,
                title: { it: 'Foo', en: 'Bar' }
              )
            end

            let(:fields) do
              [
                double(
                  'Agave::Local::JsonApiEntity(Field)',
                  position: 1,
                  api_key: 'title',
                  localized: true,
                  field_type: 'string',
                  appeareance: { type: 'plain' }
                )
              ]
            end

            it 'returns the value for the current locale' do
              I18n.with_locale(:it) do
                expect(item.title).to eq 'Foo'
              end
            end

            context 'non existing value' do
              it 'raises nil' do
                I18n.with_locale(:ru) do
                  expect(item.title).to eq nil
                end
              end
            end

            context 'fallbacks' do
              let(:entity) do
                double(
                  'Agave::Local::JsonApiEntity(Item)',
                  id: '14',
                  item_type: item_type,
                  title: { ru: nil, "es-ES": 'Bar' }
                )
              end

              it 'uses them' do
                I18n.with_locale(:ru) do
                  expect(item.title).to eq 'Bar'
                end
              end
            end
          end
        end

        context 'non existing field' do
          it 'raises NoMethodError' do
            expect(item.respond_to?(:qux)).to be_falsy
            expect { item.qux }.to raise_error NoMethodError
          end
        end

        context 'non existing field type' do
          let(:fields) do
            [
              double(
                'Agave::Local::JsonApiEntity(Field)',
                position: 1,
                api_key: 'title',
                localized: false,
                field_type: 'rotfl'
              )
            ]
          end

          it 'returns the raw item value' do
            expect(item.title).to eq 'My titlè with àccents'
          end
        end
      end

      context 'equality' do
        subject(:same_item) { described_class.new(entity, repo) }

        subject(:another_item) { described_class.new(another_entity, repo) }
        let(:another_entity) do
          double(
            'Agave::Local::JsonApiEntity(Item)',
            id: '15'
          )
        end

        it 'two items are equal if their id is the same' do
          expect(item).to eq same_item
        end

        it 'else they\'re not' do
          expect(item).not_to eq another_item
          expect(item).not_to eq 'foobar'
        end
      end
    end
  end
end
