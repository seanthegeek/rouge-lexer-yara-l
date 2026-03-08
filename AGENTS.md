# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## Project Overview

A Rouge lexer plugin gem that adds syntax highlighting for YARA-L 2.0, the detection and search query language used by Google Security Operations (formerly Chronicle). It extends Rouge's `RegexLexer` base class.

## Commands

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rake spec

# Run a single test
bundle exec ruby spec/rouge_lexer_yaral_spec.rb -n test_name

# Start visual preview server at http://localhost:9292
bundle exec rake server

# Preview highlighting in terminal (visual sample)
bundle exec ruby preview.rb

# Debug token output
DEBUG=1 bundle exec ruby preview.rb
```

## Architecture

- `lib/rouge/lexers/yaral.rb` - The lexer implementation (`Rouge::Lexers::YARAL < RegexLexer`). Contains all keyword/function definitions and lexer states (root, multiline_comment, double_string, backtick_string, regex).
- `lib/rouge/lexer/yaral.rb` - Shim that loads the lexer from its canonical path. Required by the gem entrypoint.
- `lib/rouge-lexer-yara-l.rb` - Gem entrypoint, loads the shim.
- `spec/demos/yaral` - Short demo sample (used in tests and preview).
- `spec/visual/samples/yaral` - Comprehensive visual sample covering all YARA-L syntax elements (used in tests and preview).
- `spec/rouge_lexer_yaral_spec.rb` - Minitest tests verifying lexer discovery (tag, alias, filename, mimetype, source detection), lossless round-tripping, and absence of error tokens.
- `config.ru` / `preview.rb` - Rack app and CLI script for visual inspection of highlighting.

## Key Patterns

- The lexer registers tag `yaral` with aliases `yara-l` and `chronicle`.
- Keyword/function sets are defined as class-level `Set` objects with memoization (`@keywords ||= Set.new`).
- Tests assert that lexing demo/sample files produces no `Error` tokens and reconstructs the original input exactly (lossless round-trip).
- When adding new YARA-L keywords or functions, update both the lexer sets and the visual sample file to ensure test coverage.

## Official YARA-L documentation (use ONLY these — do not guess syntax)

**MANDATORY: Before writing or modifying the lexer, you MUST fetch and read every URL in this list.** This is not background reading — it is a required prerequisite step. Fetch each page, extract the function or command names, and verify them against the lexer before declaring any work complete.

Do not use the quick-reference or overview pages as a substitute for the individual detail pages. The quick-reference pages omit aliases, secondary functions, and command-specific keywords that only appear on the detail pages. Every page in this list exists because it contains information not fully captured elsewhere.

- Get started <https://docs.cloud.google.com/chronicle/docs/yara-l/getting-started>
- Meta section <https://docs.cloud.google.com/chronicle/docs/yara-l/meta-syntax>
- Events section <https://docs.cloud.google.com/chronicle/docs/yara-l/events-syntax>
- Match section <https://docs.cloud.google.com/chronicle/docs/yara-l/match-syntax>
- Outcome section <https://docs.cloud.google.com/chronicle/docs/yara-l/outcome-syntax>
- Conditions section <https://docs.cloud.google.com/chronicle/docs/yara-l/condition-syntax>
- Options section <https://docs.cloud.google.com/chronicle/docs/yara-l/options-syntax>
- Expressions, operators, and other constructs <https://docs.cloud.google.com/chronicle/docs/yara-l/expressions>
- Nested if statements <https://docs.cloud.google.com/chronicle/docs/yara-l/nested-if>
- Use OR syntax in the condition section <https://docs.cloud.google.com/chronicle/docs/yara-l/multievent-or>
- Use N OF syntax with event variables <https://docs.cloud.google.com/chronicle/docs/yara-l/multievent-n-of>
- Repeated fields <https://docs.cloud.google.com/chronicle/docs/yara-l/repeated-fields>
- Reference list syntax <https://docs.cloud.google.com/chronicle/docs/yara-l/reference-list-syntax>
- Detection event sampling <https://docs.cloud.google.com/chronicle/docs/yara-l/detection-event-sampling>
- Functions <https://docs.cloud.google.com/chronicle/docs/yara-l/functions>
- Statistics and aggregations <https://docs.cloud.google.com/chronicle/docs/investigation/statistics-aggregations-in-udm-search>
- Use conditions in Search and Dashboards <https://docs.cloud.google.com/chronicle/docs/investigation/yara-l-2-0-conditions>
- Create and save visualizations in Search <https://docs.cloud.google.com/chronicle/docs/reports/visualization-in-search>
- Use metrics in Search <https://docs.cloud.google.com/chronicle/docs/investigation/yara-l-2-0-metrics-search>
- Use deduplication in Search and Dashboards <https://docs.cloud.google.com/chronicle/docs/investigation/deduplication-yaral>
- Create multi-stage queries <https://docs.cloud.google.com/chronicle/docs/investigation/multi-stage-yaral>
- Use context-enriched data in rules <https://docs.cloud.google.com/chronicle/docs/detection/use-enriched-data-in-rules>
- Context-aware analysis overview <https://docs.cloud.google.com/chronicle/docs/detection/context-aware-analytics>
- Specify entity risk score in rules <https://docs.cloud.google.com/chronicle/docs/detection/yara-l-entity-risk-score>
- Use metric functions for Risk Analytics rules <https://docs.cloud.google.com/chronicle/docs/detection/metrics-functions>
- Applied Threat Intelligence fusion feed overview <https://docs.cloud.google.com/chronicle/docs/detection/ati-fusion-feed>
- Composite detections overview <https://docs.cloud.google.com/chronicle/docs/detection/composite-detections>
- Construct composite detection rules <https://docs.cloud.google.com/chronicle/docs/yara-l/composite-detection-rules>
- Rule structure and best practices <https://docs.cloud.google.com/chronicle/docs/detection/yara-l-best-practices>
- Run a rule against historical data <https://docs.cloud.google.com/chronicle/docs/detection/run-rule-historical-data>
- Configure rule exclusions <https://docs.cloud.google.com/chronicle/docs/detection/rule-exclusions>
- View and troubleshoot rule errors <https://docs.cloud.google.com/chronicle/docs/detection/rule-errors>
- Known issues and limitations <https://docs.cloud.google.com/chronicle/docs/detection/yara-l-issues>
- Examples: YARA-L 2.0 queries <https://docs.cloud.google.com/chronicle/docs/yara-l/yara-l-2-0-examples>
- Sample YARA-L 2.0 queries for dashboards <https://docs.cloud.google.com/chronicle/docs/reference/sample-yaral-for-native-dashboard>
- Transition from SPL to YARA-L 2.0 <https://docs.cloud.google.com/chronicle/docs/yara-l/transition_spl_yaral>

### Important context

YARA-L 2.0 is used in three contexts within Google SecOps, and the lexer must handle all of them:

1. **Detection rules** — structured rules.
2. **Search queries** — UDM search with statistical/aggregation keywords
3. **Dashboard queries** — similar to search queries but with dashboard-specific functions  and a required `match` section.

## Rouge references

- Lexer development guide: <https://github.com/rouge-ruby/rouge/blob/main/docs/LexerDevelopment.md>
- Existing lexers for reference: <https://github.com/rouge-ruby/rouge/tree/main/lib/rouge/lexers>
- JSON lexer (simple example): <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/lexers/json.rb>
- SQL lexer (closest analog): <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/lexers/sql.rb>
- Token types: <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/token.rb>

### Testing and iterating

Use the visual preview server as a feedback loop.

1. Run `bundle exec rake`. Fix any failures.
2. Start the visual preview server: `bundle exec puma -d -p 9292`.
3. Count Error tokens:

   ```bash
   curl -s http://localhost:9292/yaral | grep -o 'class="err"' | wc -l
   ```

4. If there are Error tokens, identify what's causing them:

   ```bash
   curl -s http://localhost:9292/yaral | grep -oP '<span class="err">[^<]*</span>' | sort -u
   ```

5. For each Error token:
   a. Identify what syntax element the unmatched text represents.
   b. Verify against the official docs that the syntax is valid.
   c. Fix the lexer rule to handle it.
   d. Re-run `bundle exec rake` to confirm no regressions.
   e. Re-fetch to check if the Error token is gone.
6. Repeat until the Error token count is **zero** for both the visual sample and the demo.
7. Do a final visual sanity check — fetch the HTML and confirm that keywords, functions, operators, strings, numbers, comments, and variables are each distinctly highlighted.
8. Kill the puma server when done.

### Fetching Google docs pages

Google docs pages are JavaScript-rendered SPAs. Normal `curl` or `WebFetch` calls return empty/nav-only content. You **must** use the Googlebot User-Agent to get rendered content:

```bash
curl -s -H 'User-Agent: Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)' '<URL>'
```

### Verification workflow (MANDATORY — do this BEFORE adding anything)

Before adding ANY keyword, function, or syntax element to the lexer:

1. **Fetch the relevant documentation page** using `curl` with the Googlebot UA (see above).
2. **Extract and confirm** the element exists in the fetched HTML. Do not rely on training data, memory, or assumptions about what "should" exist.
3. **For functions specifically**, extract the complete function list from the official [functions reference](https://docs.cloud.google.com/chronicle/docs/yara-l/functions) and diff against what's already in the lexer:

   ```bash
   # Extract namespaced functions from the official docs page
   curl -s -H 'User-Agent: Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)' \
     'https://docs.cloud.google.com/chronicle/docs/yara-l/functions' | \
     python3 -c "import sys,re; [print(m) for m in sorted(set(re.findall(r'\b(\w+\.\w+)\s*\(', sys.stdin.read())))]"
   ```

4. **Only add** elements that appear in the fetched content. **Only remove** elements confirmed absent.

### Confirmed absent from YARA-L 2.0 (do NOT re-add)

The following elements have been verified against the full official documentation and are **not** present in YARA-L 2.0. They were previously in the lexer and removed. Do not re-add them.

| Element | Why it was removed |
| ------- | ------------------ |
| `for` keyword | YARA keyword; not used in YARA-L 2.0. N-of syntax is `N of [...]`, not `for N of [...]`. |
| `arrays.contains` function | Not in the YARA-L 2.0 functions reference. |
| `strings.starts_with` function | Not in the YARA-L 2.0 functions reference. |
| `metrics.functionName` function | Was a placeholder; replaced with the real `metrics.*` function list. |

### What NOT to do

- **Do NOT add functions, keywords, or syntax from training data or memory.** Every addition must be traced to a specific URL from the reference list in this file.
- **Do NOT use preview/beta features** unless explicitly asked. Only add GA (generally available) features.
- **Do NOT fabricate or modify reference URLs.** Use ONLY the exact URLs listed in this file. If a URL doesn't work, say so — do not guess an alternative.
- **Do NOT assume a function exists because a similar one does** (e.g., don't infer `strings.length` from `arrays.length`, or `hash.md5` from `hash.sha256`).
- **Do NOT include information or concepts from the YARA documentation**. YARA and YARA-L have similar names but are distinct.
- **Do Not assume that terms or concepts from YARA or SQL apply to YARA-L**. Again, only official use **OFFICIAL YARA-L documentation.

### Self-verification

After making changes, verify correctness by **re-fetching the source documentation** and confirming every added element appears in the fetched HTML. Do not verify by re-reading your own changes — verify against the external source.

### Constraints (applies to all work)

- **No hallucinated syntax.** Every keyword, function, operator, and language construct in the lexer must come from the official documentation listed above.
- **Follow Rouge conventions exactly.** Study existing lexers (especially JSON and SQL) for patterns. Don't invent novel approaches.
- **The Error token count is the ground truth.** The visual preview server is the authoritative test. `bundle exec rake` passing is necessary but not sufficient — you must also have zero `class="err"` spans.
- **Iterate until clean.** Do not declare the task complete until both `bundle exec rake` passes AND the Error token count is zero for both demo and visual sample.

## Changelog

The changelog ([CHANGELOG.md](CHANGELOG.md)) follows the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format and [Semantic Versioning](https://semver.org/spec/v2.0.0.html). When updating the changelog:

- Use `## [version] - YYYY-MM-DD` for release headings
- Use `### Added`, `### Changed`, `### Removed` as second-level section headings
- Use `#### Category name` as third-level headings within a section (e.g. `#### Commands`, `#### Evaluation functions`)
- Ensure blank lines surround all headings to satisfy markdownlint
