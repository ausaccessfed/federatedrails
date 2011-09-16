# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "federated_rails"
  s.summary = %q{Integrates Shibboleth SP to rack/warden ruby web apps}
  s.description = %q{Integrates Federated Identity Sources with local Shibboleth SP to provide identity to rack/warden ruby web apps}
  s.email = %q{bradleybeddoes@gmail.com}
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile"]
  
  s.version = "0.1.0"

end
