class URI::HTTP
  def subdominate(subdomain)
    if host.start_with? 'www.'
      new_host = host.gsub('www.', "www.#{subdomain}.")
    else
      new_host = "#{subdomain}.#{host}"
    end
    URI::HTTP.build(scheme: scheme,
                    host: new_host,
                    path: path,
                    query: query,
                    port: port)
  end

  def url_for(path)
    URI.join(self, path).to_s
  end
end


module Mumukit::Platform
  def self.configure
    @config ||= defaults
    yield @config
  end

  def self.defaults
    struct.tap do |config|
      domain = platform_domain_from_env

      config.laboratory_url = ENV['MUMUKI_LABORATORY_URL'] || "http://laboratory.#{domain}"
      config.thesaurus_url = ENV['MUMUKI_THESAURUS_URL'] || "http://thesaurus.#{domain}"
      config.bibliotheca_url = ENV['MUMUKI_BIBLIOTHECA_URL'] || "http://bibliotheca.#{domain}"
      config.bibliotheca_api_url = ENV['MUMUKI_BIBLIOTHECA_API_URL'] || "http://bibliotheca-api.#{domain}"
      config.office_url = ENV['MUMUKI_OFFICE_URL'] || "http://office.#{domain}"
      config.classroom_url = ENV['MUMUKI_CLASSROOM_URL'] || "http://classroom.#{domain}"
      config.classroom_api_url = ENV['MUMUKI_CLASSROOM_API_URL'] || "http://classroom-api.#{domain}"
    end
  end

  def self.platform_domain_from_env
    if ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
      'localmumuki.io'
    else
      ENV['MUMUKI_PLATFORM_DOMAIN'] || 'mumuki.io'
    end
  end

  def self.config
    @config
  end
end

module Mumukit::Platform::WithApplications
  def laboratory_application
    Mumukit::Platform::OrganicApplication.new config.laboratory_url
  end

  def classroom_application
    Mumukit::Platform::OrganicApplication.new config.classroom_url
  end

  def office_application
    Mumukit::Platform::Application.new config.office_url
  end

  def bibliotheca_application
    Mumukit::Platform::Application.new config.bibliotheca_url
  end
end


module Mumukit::Platform
  extend Mumukit::Platform::WithApplications
end

module Mumukit::Platform
  class Application
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def uri
      URI(@url)
    end

    def organic_uri(_organization)
      uri
    end

    def organic_url(organization)
      organic_uri(organization).to_s
    end

    def domain
      uri.domain
    end

    def url_for(path)
      uri.url_for(path) if path
    end

    def organic_url_for(organization, path)
      organic_uri(organization).url_for(path)
    end
  end

  class OrganicApplication < Application
    def organic_uri(organization)
      uri.subdominated(organization)
    end
  end
end


Mumukit::Platform.configure do |_config|

end