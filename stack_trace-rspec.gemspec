# frozen_string_literal: true

require_relative "lib/stack_trace/rspec/version"

Gem::Specification.new do |spec|
  spec.name = "stack_trace-rspec"
  spec.version = StackTrace::Rspec::VERSION
  spec.authors = ["Mehmet Emin INAC"]
  spec.email = ["mehmetemininac@gmail.com"]

  spec.summary = "StackTrace Rspec integration"
  spec.description = "Automatically generates traces for test cases"
  spec.homepage = "https://github.com/meinac/stack_trace-rspec"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage

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

  spec.add_dependency "stack_trace-viz", "~> 0.6"
end
