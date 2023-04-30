# frozen_string_literal: true

require_relative "lib/flex_uri/version"

Gem::Specification.new do |spec|
  spec.name = "flex_uri"
  spec.version = FlexUri::VERSION
  spec.authors = ["Aleksandr Ulanov"]
  spec.email = ["dev.ualeks@gmail.com"]

  spec.summary = "FlexUri is a modern gem for crafting and manipulating URIs in Ruby. Its intuitive, fluent interface provides a seamless way to build, update, and combine URI components. Ideal for managing query parameters, paths, and URI segments"
  spec.homepage = "https://github.com/ualeks/flex_uri"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ualeks/flex_uri"
  spec.metadata["changelog_uri"] = "https://github.com/ualeks/flex_uri/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
