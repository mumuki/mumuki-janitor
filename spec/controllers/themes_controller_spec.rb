require 'rails_helper'

describe Api::ThemesController, type: :controller do
  context 'GET /themes/:id' do
    let!(:css) { '.some-css { color: blue }' }

    before { create :organization, name: 'orga', theme_stylesheet: css}
    before { get :show, params: { id: 'orga' } }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to eq css }
  end
end
