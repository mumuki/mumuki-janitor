require 'rails_helper'

describe 'Static assets', type: :controller do
  let!(:public_path) { Rails.public_path.to_s }
  let(:organization) { Organization.first }

  context 'SCSS' do
    let!(:scss) { "$font-stack:    Helvetica, sans-serif;\n$primary-color: #333;\n\nbody {\n\n  font: 100% $font-stack;\n  color: $primary-color;\n}" }
    let!(:css) { "body {\n  font: 100% Helvetica, sans-serif;\n  color: #333; }\n" }
    let(:path) { "#{public_path}/#{organization.theme_stylesheet_url}" }
    before { create :organization, theme_stylesheet: scss }

    it { expect(File.read path).to eq css }
  end

  context 'JavaScript' do
    let!(:javascript) { "window.a = function() { }" }
    let(:path) { "#{public_path}/#{organization.extension_javascript_url}" }
    before { create :organization, extension_javascript: javascript}

    it { expect(File.read path).to eq javascript }
  end
end
