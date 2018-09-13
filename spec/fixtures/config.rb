# frozen_string_literal: true
def helper_method_example
  puts 'A helper method'
end

agave.available_locales.each do |_locale|
  create_data_file 'site.yml', :yml, agave.site.to_hash

  directory 'posts' do
    helper_method_example

    agave.articles.each do |post|
      create_post "#{post.slug}.md" do
        frontmatter :yaml, title: post.to_hash
        content post.title
      end
    end
  end

  add_to_data_file 'foobar.toml', :toml, sitename: agave.site.name
end
