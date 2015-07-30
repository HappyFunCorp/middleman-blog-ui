# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman/blog/ui/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-blog-ui"
  spec.version       = Middleman::Blog::Ui::VERSION
  spec.authors       = ["Will Schenk"]
  spec.email         = ["wschenk@gmail.com"]

  spec.summary       = %q{Basic web UI for a middleman-blog.}
  spec.description   = %q{Basic web UI for a middleman-blog.}
  spec.homepage      = "https://github.com/HappyFunCorp/middleman-blog-ui"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency "middleman-react"
  spec.add_dependency "sprockets-coffee-react"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "react-source"
  spec.add_dependency "bootstrap-sass"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
