# frozen_string_literal: true
require 'spec_helper'
require 'pry'

module Agave
  module Site
    describe Client, :vcr do
      subject(:client) do
        Agave::Site::Client.new(
          base_url: 'http://agave.lvh.me:3001'
        )
      end

      before { client }

      describe 'Not found' do
        it 'raises Agave::ApiError' do
          expect { client.item_types.find(44) }.to raise_error Agave::ApiError
        end
      end

      describe 'Menu items' do
        let(:item_type) do
          client.item_types.create(
            name: 'Article',
            singleton: false,
            modular_block: false,
            sortable: false,
            tree: false,
            draft_mode_active: false,
            api_key: 'article',
            ordering_direction: nil,
            ordering_field: nil,
            all_locales_required: true,
            title_field: nil
          )
        end

        let(:parent_menu_item) do
          client.menu_items.create(
            label: 'Parent',
            position: 99,
            item_type: nil
          )
        end

        after do
          client.menu_items.all.each do |menu_item|
            client.menu_items.destroy(menu_item[:id])
          end

          client.item_types.all.each do |item_type|
            client.item_types.destroy(item_type[:id])
          end
        end

        #it 'fetches, creates, updates and destroys' do
        it 'fetch, create, update and destroy' do
          new_menu_item = client.menu_items.create(
            label: 'Articles',
            position: 99,
            parent: parent_menu_item[:id],
            item_type: item_type[:id]
          )

          client.menu_items.update(
            new_menu_item[:id],
            new_menu_item.merge(label: 'Manage articles')
          )

          expect(client.menu_items.all.size).to eq 3
          expect(client.menu_items.find(new_menu_item[:id])[:label]).to eq 'Manage articles'

          client.menu_items.destroy(new_menu_item[:id])
          expect(client.menu_items.all.size).to eq 2
        end
      end

      describe 'Item types' do
        after do
          client.item_types.all.each do |item_type|
            client.item_types.destroy(item_type[:id])
          end
        end

        it 'fetches, creates, updates and destroys' do
          new_item_type = client.item_types.create(
            name: 'Article',
            singleton: false,
            modular_block: false,
            sortable: false,
            tree: false,
            draft_mode_active: false,
            api_key: 'article',
            ordering_direction: nil,
            ordering_field: nil,
            all_locales_required: true,
            title_field: nil
          )


          expect(client.item_types.all.size).to eq 1

          client.item_types.update(
            new_item_type[:id],
            new_item_type.merge(name: 'Post', api_key: 'post')
          )

          expect(client.item_types.find(new_item_type[:id])[:api_key]).to eq 'post'

          duplicate = client.item_types.duplicate(
            new_item_type[:id]
          )

          expect(client.item_types.find(duplicate[:id])[:api_key]).to eq 'post_copy_1'

          client.item_types.destroy(new_item_type[:id])

          expect(client.item_types.all.size).to eq 1
        end
      end

      describe 'Fields' do
        after do
          client.item_types.all.each do |item_type|
            client.item_types.destroy(item_type[:id])
          end
        end

        let(:item_type) do
          client.item_types.create(
            name: 'Article',
            singleton: false,
            sortable: false,
            modular_block: false,
            tree: false,
            draft_mode_active: false,
            api_key: 'article',
            ordering_direction: nil,
            ordering_field: nil,
            all_locales_required: true,
            title_field: nil
          )
        end

        it 'fetches, creates, updates and destroys' do
          new_field = client.fields.create(
            item_type[:id],
            api_key: 'title',
            field_type: 'string',
            appeareance: {
              type: 'title'
            },
            label: 'Title',
            localized: false,
            position: 99,
            hint: '',
            validators: { required: {}, length: { min: 5 } }
          )

          expect(client.fields.all(item_type[:id]).size).to eq 1

          client.fields.update(
            new_field[:id],
            new_field.merge(
              label: 'Article title'
            )
          )

          expect(client.fields.find(new_field[:id])[:label]).to eq 'Article title'

          client.fields.destroy(new_field[:id])
          expect(client.fields.all(item_type[:id]).size).to eq 0
        end
      end

      describe 'Items' do
        let(:item_type) do
          client.item_types.create(
            name: 'Article',
            singleton: false,
            modular_block: false,
            sortable: false,
            tree: false,
            draft_mode_active: false,
            api_key: 'article',
            ordering_direction: nil,
            ordering_field: nil,
            all_locales_required: true,
            title_field: nil
          )
        end

        let(:text_field) do
          client.fields.create(
            item_type[:id],
            api_key: 'title',
            field_type: 'string',
            appeareance: {
              editor: 'single_line',
              parameters: { heading: true }
            },
            label: 'Title',
            localized: false,
            position: 99,
            hint: '',
            validators: { required: {}, length: { min: 5 } }
          )
        end

        let(:image_field) do
          client.fields.create(
            item_type[:id],
            api_key: 'image',
            field_type: 'file',
            appeareance: {
              editor: 'file',
              parameters: {}
            },
            label: 'Image',
            localized: false,
            position: 99,
            hint: '',
            validators: {
              required: {},
              extension: {
                predefined_list: "image"
              }
            }
          )
        end

        let(:file_field) do
          client.fields.create(
            item_type[:id],
            api_key: 'file',
            field_type: 'file',
            appeareance: {
              editor: 'file',
              parameters: {}
            },
            label: 'File',
            localized: false,
            position: 99,
            hint: '',
            validators: { required: {} }
          )
        end

        before do
          text_field
          image_field
          file_field
        end

        xit 'fetches, creates, updates and destroys' do
          new_item = client.items.create(
            item_type: item_type[:id],
            title: 'First post',
            image: client.upload_image('https://www.agavecms.com/static/2-00c287793580e47fbe1222a1d44a6e25-95c66.png'),
            file: client.upload_file('./spec/fixtures/file.txt')
          )

          expect(client.items.all('filter[type]' => item_type[:id]).size).to eq 1

          client.items.update(
            new_item[:id],
            new_item.merge(title: 'Welcome!')
          )

          expect(client.items.find(new_item[:id])[:title]).to eq 'Welcome!'

          client.items.destroy(new_item[:id])
          expect(client.items.all('filter[type]' => item_type[:id]).size).to eq 0
        end
      end

      describe 'Users' do
        after do
          client.users.all.each do |user|
            client.users.destroy(user[:id])
          end
        end

        it 'fetches, creates and destroys' do
          role = client.roles.all.first

          user = client.users.create(
            email: 'foo@bar.it',
            first_name: 'Foo',
            last_name: 'Bar',
            role: role[:id]
          )

          expect(client.users.all.size).to eq(1)

          fetched_user = client.users.find(user[:id])
          expect(fetched_user[:first_name]).to eq 'Foo'

          client.users.destroy(user[:id])
        end
      end

      describe 'Site' do
        after do
          # client
        end

        it 'fetch, update' do
          site = client.site.find
          client.site.update(site.merge(name: 'My Blog'))
          expect(client.site.find[:name]).to eq 'My Blog'
        end
      end
    end
  end
end
