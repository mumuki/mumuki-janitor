require 'auth0'

namespace :users do
  task populate: :environment do
    puts "Migrating users from auth0...\n\n\n"

    auth0 = Auth0Client.new(
        :client_id => ENV['MUMUKI_AUTH_CLIENT_ID'],
        :token => ENV['MUMUKI_AUTH_API_TOKEN'],
        :domain => "mumuki.auth0.com",
        :api_version => 2
    )
    page = 0
    users = auth0.get_users per_page: 100
    while users.present?
      page += 1
      puts "Migrating page #{page} from auth0...\n\n\n"
      users.each do |user|
        create_user(user)
      end
      users = auth0.get_users(page: page, per_page: 100)
    end
  end
end

def create_user(u)
  first_name = u['given_name'] || u['name'].split(' ').first
  last_name = u['family_name'] || u['name'].split(' ').last
  user_params = {
      first_name: first_name,
      last_name: last_name,
      email: u['email'],
      uid: u['email'] || u['user_id'],
      permissions: {
          student: u.dig('app_metadata', 'atheneum', 'permissions'),
          teacher: u.dig('app_metadata', 'classroom', 'permissions'),
          janitor: u.dig('app_metadata', 'admin', 'permissions'),
          writer: u.dig('app_metadata', 'bibliotheca', 'permissions'),
      }.compact
  }
  user = User.where(uid: user_params[:uid]).assign_first user_params.except(:permissions)
  user.update_permissions! user_params[:permissions]
  user.notify!
rescue => e
  puts "Couldn't create #{u['email']} because of:\n\n #{e}"
end
