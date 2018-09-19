lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'botinsta/version'

Gem::Specification.new do |spec|
  spec.name          = 'botinsta'
  spec.version       = Botinsta::VERSION
  spec.authors       = ['andreyuhai']
  spec.email         = ['yuhai.ndre@gmail.com']

  spec.summary       = 'Ruby Instagram bot'
  spec.description   = 'An Instagram bot working without any API.'
  spec.homepage      = 'https://github.com/andreyuhai/botinsta'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'colorize',     ['~> 0.8.1']
  spec.add_runtime_dependency 'hashie',       ['~> 3.6']
  spec.add_runtime_dependency 'mechanize',    ['~> 2.7', '>= 2.7.6']
  spec.add_runtime_dependency 'nokogiri',     ['~> 1.8', '>= 1.8.4']
  spec.add_runtime_dependency 'pry',          ['~> 0.11.3']
  spec.add_runtime_dependency 'rb-readline',  ['~> 0.5.5']
  spec.add_runtime_dependency 'sequel',       ['~> 5.12']
  spec.add_runtime_dependency 'sqlite3',      ['~> 1.3', '>= 1.3.13']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
