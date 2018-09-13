# frozen_string_literal: true
require 'spec_helper'

module Agave
  module Upload
    describe File, :vcr do
      let(:site) do; end

      before { site }

      let(:site_client) do; end

      subject(:command) do
        described_class.new(site_client, source)
      end

      context 'with a local file' do
        let(:source) { './spec/fixtures/image.jpg' }

        xit 'uploads the file' do
        end
      end
    end
  end
end
