$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'chargehound/version'

Gem::Specification.new do |spec|
  spec.name        = 'chargehound'
  spec.version     = Chargehound::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 1.9.3'
  spec.authors     = ['Chargehound']
  spec.email       = ['support@chargehound.com']
  spec.homepage    = 'https://www.chargehound.com'
  spec.summary     = 'Ruby bindings for the Chargehound API'
  spec.description = 'Automatically fight disputes'
  spec.license     = 'MIT'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_development_dependency 'rake', '~> 11.1'
  spec.add_development_dependency 'rubocop', '~> 0.49'
  spec.add_development_dependency 'webmock', '~> 2.3'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ['lib']
  spec.extra_rdoc_files = ['README.md']
end
