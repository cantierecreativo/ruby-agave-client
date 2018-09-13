# frozen_string_literal: true
require 'spec_helper'

module Agave
  module Dump
    RSpec.describe SsgDetector do
      subject(:detector) { described_class.new(path) }

      describe '.detect' do
        context 'otherwise' do
          let(:path) { '.' }

          it 'fall backs to "unknown"' do
            expect(detector.detect).to eq 'unknown'
          end
        end
      end
    end
  end
end
