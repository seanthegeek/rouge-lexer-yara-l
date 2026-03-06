# frozen_string_literal: true

require 'minitest/autorun'
require 'rouge'
require 'rouge/lexer/yaral'

class RougeLexerYARALTest < Minitest::Test
  def setup
    @lexer = Rouge::Lexers::YARAL.new
  end

  def test_finds_by_tag
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.find('yaral')
  end

  def test_finds_by_alias
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.find('yara-l')
  end

  def test_finds_by_alias_chronicle
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.find('chronicle')
  end

  def test_guesses_by_filename_yaral
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.guess(filename: 'rules.yaral')
  end

  def test_guesses_by_filename_yara_l
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.guess(filename: 'rules.yara-l')
  end

  def test_guesses_by_mimetype
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.guess(mimetype: 'text/x-yaral')
  end

  def test_guesses_by_source_rule
    source = 'rule TestRule {'
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.guess(source: source)
  end

  def test_guesses_by_source_events
    source = "events:\n  \$e.metadata.event_type = \"USER_LOGIN\""
    assert_equal Rouge::Lexers::YARAL, Rouge::Lexer.guess(source: source)
  end

  def test_demo_preserves_input
    demo = load_demo
    output = @lexer.lex(demo).map { |_, val| val }.join
    assert_equal demo, output, 'Lexer output does not reconstruct the demo input'
  end

  def test_sample_preserves_input
    sample = load_sample
    output = @lexer.lex(sample).map { |_, val| val }.join
    assert_equal sample, output, 'Lexer output does not reconstruct the sample input'
  end

  def test_no_error_tokens_in_demo
    demo = load_demo
    errors = collect_errors(demo)
    assert_empty errors, "Demo produced error tokens:\n#{format_errors(errors)}"
  end

  def test_no_error_tokens_in_sample
    sample = load_sample
    errors = collect_errors(sample)
    assert_empty errors, "Visual sample produced error tokens:\n#{format_errors(errors)}"
  end

  private

  def load_demo
    path = File.join(__dir__, 'demos', 'yaral')
    File.read(path)
  end

  def load_sample
    path = File.join(__dir__, 'visual', 'samples', 'yaral')
    File.read(path)
  end

  def collect_errors(text)
    @lexer.lex(text).select { |tok, _| tok == Rouge::Token::Tokens::Error }
  end

  def format_errors(errors)
    errors.map { |_, val| "  #{val.inspect}" }.join("\n")
  end
end
