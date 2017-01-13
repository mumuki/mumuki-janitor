FactoryGirl.define do
  def api_client(name, role, slug)
    factory name do
      description "foo"
      user { create :user, first_name: 'foo', last_name: 'bar', email: 'foo+1@bar.com', permissions: Hash[role, slug] }
    end
  end

  api_client :api_client, :janitor, "test/*"
  api_client :api_client_god, :owner, "*"
  api_client :api_client_owner, :owner, "test/*"
end
