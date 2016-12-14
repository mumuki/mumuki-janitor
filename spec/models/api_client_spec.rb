require 'rails_helper'

describe ApiClient, type: :model do
  let(:api_client) {create :api_client}
  it { expect(api_client.token).to eq Mumukit::Auth::Token.generate_token }
end
