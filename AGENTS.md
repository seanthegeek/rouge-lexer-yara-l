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

## Official references (use ONLY these — do not guess syntax)

Use these to understand the language,

### Core language

- YARA-L overview: <https://docs.cloud.google.com/chronicle/docs/yara-l/yara-l-overview>
- YARA-L 2.0 language syntax: <https://cloud.google.com/chronicle/docs/detection/yara-l-2-0-syntax>
- Meta section syntax: <https://docs.cloud.google.com/chronicle/docs/yara-l/meta-syntax>
- Events section syntax: <https://docs.cloud.google.com/chronicle/docs/yara-l/events-syntax>
- Match section syntax <https://docs.cloud.google.com/chronicle/docs/yara-l/match-syntax>
- Outcome section syntax <https://docs.cloud.google.com/chronicle/docs/yara-l/outcome-syntax>
- Condition section syntax <https://docs.cloud.google.com/chronicle/docs/yara-l/condition-syntax>
- Options section syntax: <https://docs.cloud.google.com/chronicle/docs/yara-l/options-syntax>
- Expressions, operators, and constructs: <https://docs.cloud.google.com/chronicle/docs/yara-l/expressions>
- Use nested if statements for more complex logic: <https://docs.cloud.google.com/chronicle/docs/yara-l/nested-if>
- Use or in the condition section: <https://docs.cloud.google.com/chronicle/docs/yara-l/multievent-or>
- Use N OF syntax with event variables: <https://docs.cloud.google.com/chronicle/docs/yara-l/multievent-n-of>
- Repeated fields: <https://docs.cloud.google.com/chronicle/docs/yara-l/repeated-fields>
- Use reference lists and data tables in YARA-L 2.0: <https://docs.cloud.google.com/chronicle/docs/yara-l/reference-list-syntax>
- Functions reference: <https://docs.cloud.google.com/chronicle/docs/yara-l/functions>
- YARA-L 2.0 examples: <https://docs.cloud.google.com/chronicle/docs/yara-l/yara-l-2-0-examples>

### Detection rules

- YARA-L best practices: <https://cloud.google.com/chronicle/docs/detection/yara-l-best-practices>
- Composite detection rules: <https://docs.cloud.google.com/chronicle/docs/yara-l/composite-detection-rules>
- Default detection rules (examples): <https://docs.cloud.google.com/chronicle/docs/detection/default-rules>
- Chronicle detection-rules GitHub: <https://github.com/chronicle/detection-rules>

### Search queries

- Search for events and alerts: <https://docs.cloud.google.com/chronicle/docs/investigation/udm-search>
- Search best practices: <https://docs.cloud.google.com/chronicle/docs/investigation/udm-search-best-practices>
- Understand data availability for search: <https://docs.cloud.google.com/chronicle/docs/investigation/expected-data-availability-for-search>
- Use context-enriched data in search: <https://docs.cloud.google.com/chronicle/docs/investigation/use-enriched-data-in-search>
- Use UDM Search to investigate an entity: <https://docs.cloud.google.com/chronicle/docs/investigation/udm-search-investigate-entity>
Use UDM Search time range and manage queries: <https://docs.cloud.google.com/chronicle/docs/investigation/udm-search-time-range>
- Search joins: <https://docs.cloud.google.com/chronicle/docs/investigation/search-joins>
- Correlate data with outer joins: <https://docs.cloud.google.com/chronicle/docs/investigation/outer-joins>
- Statistics and aggregations in search: <https://docs.cloud.google.com/chronicle/docs/investigation/statistics-aggregations-in-udm-search>
- Conditions in search and dashboards: <https://docs.cloud.google.com/chronicle/docs/investigation/yara-l-2-0-conditions>
- Multi-stage queries: <https://docs.cloud.google.com/chronicle/docs/investigation/multi-stage-yaral>
- Use the condition syntax in search and dashboards: <https://docs.cloud.google.com/chronicle/docs/investigation/yara-l-2-0-conditions>
- Use deduplication in Search and Dashboards: <https://docs.cloud.google.com/chronicle/docs/investigation/deduplication-yaral>
- Control columns using select and unselect keywords: <https://docs.cloud.google.com/chronicle/docs/investigation/select-unselect>
- Use metrics in search: <https://docs.cloud.google.com/chronicle/docs/investigation/yara-l-2-0-metrics-search>
- Conduct a search for entity context data <https://docs.cloud.google.com/chronicle/docs/investigation/entity-context-in-search>
- Conduct a raw log search: <https://docs.cloud.google.com/chronicle/docs/investigation/raw-log-search-in-investigate>
- Use raw log search: <https://docs.cloud.google.com/chronicle/docs/investigation/search-raw-logs>
- Filter data in raw log search <https://docs.cloud.google.com/chronicle/docs/investigation/search-raw-logs>

### Dashboards

- Dashboard-specific functions: <https://docs.cloud.google.com/chronicle/docs/reference/yaral-functions-native-dashboards>
- Sample dashboard queries: <https://docs.cloud.google.com/chronicle/docs/reference/sample-yaral-for-native-dashboard>
- Dashboards overview: <https://docs.cloud.google.com/chronicle/docs/reports/native-dashboards>

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
