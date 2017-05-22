workers Integer(ENV['MUMUKI_OFFICE_WORKERS'] || 2)
threads_count = Integer(ENV['MUMUKI_OFFICE_THREADS'] || 1)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['MUMUKI_OFFICE_PORT']           || 3005
environment ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
