FactoryGirl.define do
  factory :organization do
    name "my-string"
    description "MyText"
    books ["MyString"]
    logo_url "MyString"
    login_methods ["MyString"]
    locale "es-AR"
    public true
    contact_email "MyString"
    theme_stylesheet ""
    extension_javascript ""
    terms_of_service nil
  end
end
