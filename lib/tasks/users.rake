require 'auth0'

namespace :users do
  task populate: :environment do
    puts "Migrating users from auth0...\n\n\n"

    auth0 = create_auth0_client
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
  task :import, [:social_id] do |_, args|
    social_id = args[:social_id]
    puts "Importing user #{social_id} from auth0...\n\n\n"

    auth0 = create_auth0_client
    auth0_profile = auth0.user(social_id)
    create_user auth0_profile
  end
end

def create_auth0_client
  Auth0Client.new(
        :client_id => ENV['MUMUKI_AUTH0_CLIENT_ID'],
        :token => ENV['MUMUKI_AUTH0_API_TOKEN'],
        :domain => "mumuki.auth0.com",
        :api_version => 2)
end

def create_user(u)
  first_name = u['given_name'] || u['name'].split(' ').first
  last_name = u['family_name'] || u['name'].split(' ').last
  uid =  u['email'] || u['user_id']
  user_params = {
      first_name: first_name,
      last_name: last_name,
      email: u['email'],
      social_id: u['user_id'],
      image_url: u['picture'],
      uid: uid,
      permissions: {
          student: u.dig('app_metadata', 'atheneum', 'permissions'),
          teacher: u.dig('app_metadata', 'classroom', 'permissions'),
          janitor: u.dig('app_metadata', 'admin', 'permissions'),
          writer: u.dig('app_metadata', 'bibliotheca', 'permissions'),
      }.compact
  }
  user = User.find_by!(uid: user_params[:uid])
  puts "  Omitting user #{user_params[:uid]}. He has permissions already\n\n" unless user.permissions.as_json.empty?
  return unless user.permissions.as_json.empty?
  puts "  Auth0  User: #{user_params[:uid]}"
  puts "         Permissions: #{u.dig('app_metadata')}\n"
  puts "  Mumuki User: #{user.uid}"
  puts "         Permissions: #{user.permissions.as_json}"
  puts "         New Permissions:#{user_params[:permissions]}\n\n\n"
#  user = User.where(uid: user_params[:uid]).assign_first user_params.except(:permissions)
  user.update_permissions! user_params[:permissions]
  user.notify!
rescue => e
  puts "Couldn't create #{u['email']} because of: #{e}"
end
