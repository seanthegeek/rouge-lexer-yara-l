# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'rouge-lexer-yara-l'
  s.version     = '0.1.0'
  s.summary     = 'Rouge lexer for YARA-L'
  s.description = 'A Rouge plugin providing syntax highlighting for ' \
                  'YARA-L 2.0, the detection and search query language used by Google Security Operations'
  s.authors     = ['Sean Whalen']
  s.homepage    = 'https://github.com/seanthegeek/rouge-lexer-yara-l'
  s.license     = 'MIT'
  s.files       = Dir['lib/**/*.rb'] + Dir['spec/demos/*'] + Dir['spec/visual/samples/*']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'rouge', '>= 3.0'

  s.metadata = {
    'source_code_uri' => 'https://github.com/seanthegeek/rouge-lexer-yara-l',
    'bug_tracker_uri' => 'https://github.com/seanthegeek/rouge-lexer-yara-l/issues'
  }
end
