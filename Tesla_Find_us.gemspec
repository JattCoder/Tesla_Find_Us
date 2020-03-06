require_relative 'lib/Tesla_Find_us/version'

Gem::Specification.new do |spec|
  spec.name          = "Tesla_Find_us"
  spec.version       = TeslaFindUs::VERSION
  spec.authors       = ["Harmandeep S. Mand"]
  spec.email         = ["harmandeepmand.hm@gmail.com"]

  spec.summary       = %q{Tesla Find Us}
  spec.description   = %q{Locate Tesla superchargers near by and/or on your way to your destination.}
  spec.homepage      = "https://github.com/JattCoder"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/JattCoder/Tesla_Find_Us.git"
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
