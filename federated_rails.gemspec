# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = "federated_rails"
  s.version     = "0.3.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bradley Beddoes"]
  s.email       = ["bradleybeddoes@gmail.com"]
  s.homepage    = "https://github.com/ausaccessfed/federatedrails"
  s.summary     = %q{SAML federation authentication and access control}
  s.description = %q{Allows Ruby on Rails applications to easily integrate to federated authentication sources particuarly those served by Shibboleth service providers.}

  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile"]
end
