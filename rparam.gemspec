$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rparam/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rparam"
  spec.version     = Rparam::VERSION
  spec.authors     = ["kmdtmyk"]
  spec.email       = ["winback_banderas@yahoo.co.jp"]
  spec.homepage    = "https://github.com/kmdtmyk/rparam"
  spec.summary     = "Summary of Rparam."
  spec.description = "Description of Rparam."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'rails', '>= 5.0.0'

  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'webrick'
  spec.add_development_dependency 'rspec-rails', '~> 5.1', '>= 5.1.1'

end
