RSpec.shared_context 'with a new site' do
  let(:client) do
    Agave::Site::Client.new(
      base_url: 'http://site-api.lvh.me:3001'
    )
  end

  let(:item_type) do
    client.item_types.create(
      name: 'Article',
      singleton: false,
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
          type: 'title',
      },
      label: 'Title',
      localized: true,
      position: 99,
      hint: '',
      validators: { required: {}, length: { min: 5 } }
    )
  end

  let(:slug_field) do
    client.fields.create(
      item_type[:id],
      api_key: 'slug',
      field_type: 'slug',
      appeareance: {
        title_field_id: text_field[:id].to_s,
        url_prefix: nil
      },
      label: 'Slug',
      localized: false,
      position: 99,
      hint: '',
      validators: { required: {} }
    )
  end

  let(:image_field) do
    client.fields.create(
      item_type[:id],
      api_key: 'image',
      field_type: 'image',
      appeareance: {
        editor: 'file',
        extensions: ['png']
      },
      label: 'Image',
      localized: false,
      position: 99,
      hint: '',
      validators: {
        required: {}
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
        parameters: {},
      },
      label: 'File',
      localized: false,
      position: 99,
      hint: '',
      validators: { required: {} }
    )
  end

  let(:item) do
    client.items.create(
      item_type: item_type[:id],
      title: {
        en: 'First post',
        it: 'Primo post'
      },
      slug: 'first-post',
    )
  end

  before do
    client.site.update(
      client.site.find.merge(
        locales: ['en', 'it'],
        theme: {
          primary_color: {
            red: 63,
            green: 63,
            blue: 63,
            alpha: 63
          },
          dark_color: {
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0
          },
          light_color: {
            red: 127,
            green: 127,
            blue: 127,
            alpha: 127
          },
          accent_color: {
            red: 255,
            green: 255,
            blue: 255,
            alpha: 255
          }
        }
      )
    )

    item_type
    text_field
    slug_field
    image_field
    file_field
    item
  end

  after do
    client.menu_items.all.each do |menu_item|
      client.menu_items.destroy(menu_item[:id])
    end

    client.item_types.all.each do |item_type|
      client.item_types.destroy(item_type[:id])
    end
  end
end
