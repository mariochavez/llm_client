# frozen_string_literal: true

require_relative "lib/llm_client/version"

Gem::Specification.new do |spec|
  spec.name = "llm_client"
  spec.version = LlmClient::VERSION
  spec.authors = ["Mario Alberto Chávez"]
  spec.email = ["mario.chavez@gmail.com"]

  spec.summary = "Ruby client for LLM Server."
  spec.description = "Ruby client to connect to LLM Server."
  spec.homepage = "https://mariochavez.io"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mariochavez/llm_client"
  spec.metadata["changelog_uri"] = "https://github.com/mariochavez/llm_client/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end + Dir.glob("lib/.rbnext/**/*")
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "http", "~> 5.1", ">= 5.1.1"
  spec.add_dependency "dry-monads", "~> 1.6"

  if ENV["RELEASING_GEM"].nil? && File.directory?(File.join(__dir__, ".git"))
    spec.add_runtime_dependency "ruby-next", ">= 0.15.0"
  else
    spec.add_dependency "ruby-next-core", ">= 0.15.0"
  end

  spec.add_development_dependency "ruby-next", ">= 0.15.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
