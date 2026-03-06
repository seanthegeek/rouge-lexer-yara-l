# rouge-lexer-yara-l

A Rouge lexer plugin for [YARA-L 2.0](https://cloud.google.com/chronicle/docs/detection/yara-l-2-0-overview), the detection and search query language used by [Google Security Operations](https://cloud.google.com/security/products/security-operations) (Chronicle). Rouge is the default syntax highlighter for Jekyll (and therefore GitHub Pages). This gem adds YARA-L support to Rouge.

## Installation

Install the gem directly:

```
gem install rouge-lexer-yara-l
```

Or add it to your `Gemfile`:

```
gem 'rouge-lexer-yara-l'
```

Then run:

```
bundle install
```

## Usage

Once installed, Rouge will automatically discover the lexer. You can use `yaral`, `yara-l`, or `chronicle` as the language tag in fenced code blocks:

````yaral
rule SuspiciousLogin {
  meta:
    author = "security-team"
    severity = "HIGH"

  events:
    $e.metadata.event_type = "USER_LOGIN"
    $e.security_result.action = "FAIL"
    $user = $e.target.user.userid

  match:
    $user over 5m

  condition:
    $e
}
````

## Jekyll / GitHub Pages

Add the gem to your site's `Gemfile` inside the `:jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem "rouge-lexer-yara-l"
end
```

Run `bundle install`, then use ` ```yaral ` fences in your posts and pages. Jekyll will pick up the lexer automatically via Rouge's plugin discovery.

## Development

Install dependencies:

```
bundle install
```

Run the test suite:

```
bundle exec rake
```

Start the visual preview server (available at http://localhost:9292):

```
bundle exec rake server
```

Run the terminal preview script:

```
ruby preview.rb
```

Enable debug mode to print each token and its value:

```
DEBUG=1 ruby preview.rb
```

### Iterative testing workflow

1. Run `bundle exec rake` to check for test failures and error tokens.
2. Start the server with `bundle exec rake server`.
3. In another terminal, check for error tokens in the rendered output:

   ```
   curl -s http://localhost:9292 | grep 'class="err"'
   ```

4. Fix any error tokens in `lib/rouge/lexers/yaral.rb`.
5. Repeat until no error tokens remain.

## License

MIT
