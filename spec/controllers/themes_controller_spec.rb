require 'rails_helper'

describe Api::ThemesController, type: :controller do
  context 'GET /themes/:id' do
    let!(:scss) { "$font-stack:    Helvetica, sans-serif;\n$primary-color: #333;\n\nbody {\n\n  font: 100% $font-stack;\n  color: $primary-color;\n}" }
    let!(:css) { "body {\n  font: 100% Helvetica, sans-serif;\n  color: #333; }\n" }

    before { create :organization, name: 'orga', theme_stylesheet: scss }
    before { get :show, params: { id: 'orga' } }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to eq css }
  end
end
