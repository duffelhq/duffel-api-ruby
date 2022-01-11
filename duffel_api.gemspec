# frozen_string_literal: true

require_relative "lib/duffel_api/version"

Gem::Specification.new do |spec|
  spec.name          = "duffel_api"
  spec.version       = DuffelAPI::VERSION
  spec.authors       = ["The Duffel team"]
  spec.email         = ["help@duffel.com"]

  spec.summary       = "A Ruby client for interacting with the Duffel API"
  spec.homepage      = "https://github.com/duffelhq/duffel-api-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/duffelhq/duffel-api-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{\A(?:test|spec|features|gemfiles|.circleci|.github)/})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base16", "~> 0.0.2"
  spec.add_dependency "faraday", ">= 0.9.2", "< 3"

  spec.add_development_dependency "appraisal", "~> 2.4"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata = {
    "rubygems_mfa_required" => "true",
  }
end
