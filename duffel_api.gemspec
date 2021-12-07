# frozen_string_literal: true

require_relative "lib/duffel_api/version"

Gem::Specification.new do |spec|
  spec.name = "duffel_api"
  spec.version = DuffelAPI::VERSION
  spec.authors = ["Duffel Technology Limited"]
  spec.email = ["help@duffel.com"]

  spec.summary = "Ruby client library for the Duffel API."
  spec.description = spec.summary
  spec.homepage = "https://duffel.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
