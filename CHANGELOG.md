# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.2]

### Added

#### Keywords

- `cidr` — reference-list modifier used in `$e.ip in cidr %list` expressions
- `regex` — reference-list modifier used in `$e.field in regex %list` expressions

### Removed

#### Keywords

- `for` — not a YARA-L 2.0 keyword; was a holdover from the YARA language

## [0.3.1] - 2026-03-07

### Added

#### Metrics functions

- `metrics.alert_event_name_count`
- `metrics.auth_attempts_fail`
- `metrics.auth_attempts_success`
- `metrics.auth_attempts_total`
- `metrics.dns_bytes_outbound`
- `metrics.dns_queries_fail`
- `metrics.dns_queries_success`
- `metrics.dns_queries_total`
- `metrics.file_executions_fail`
- `metrics.file_executions_success`
- `metrics.file_executions_total`
- `metrics.http_queries_fail`
- `metrics.http_queries_success`
- `metrics.http_queries_total`
- `metrics.network_bytes_inbound`
- `metrics.network_bytes_outbound`
- `metrics.network_bytes_total`
- `metrics.resource_creation_success`
- `metrics.resource_creation_total`
- `metrics.resource_deletion_success`
- `metrics.resource_read_fail`
- `metrics.resource_read_success`

### Removed

#### Metrics functions

- `metrics.functionName` — placeholder removed and replaced with the full verified function list above

## [0.3.0] - 2026-03-06

### Added

#### Keywords

- `left`, `right`, `join`, `outer` — join type keywords for multi-stage queries
- `every` — time granularity modifier (`over every 1h`)
- `stage` — introduces a named query stage in multi-stage queries

#### Aggregation functions

- `earliest` — returns the earliest timestamp value in the window
- `latest` — returns the latest timestamp value in the window

#### Evaluation functions

- `cast.as_int` — casts a value to integer

### Changed

#### Variables and field paths

- Replaced the single `$name` variable rule with three distinct rules to correctly tokenize:
  - Variables with map-access paths: `$e.additional.fields["key"]` (variable + attribute + string key)
  - Variables with dotted UDM paths: `$e.metadata.event_type` (variable + attribute chain)
  - Standalone variables: `$user`, `$host`

### Removed

#### Evaluation functions

- `arrays.contains` — not present in the official YARA-L 2.0 functions reference
- `strings.starts_with` — not present in the official YARA-L 2.0 functions reference

## [0.2.0] - 2026-03-05

### Added

- Shim file (`lib/rouge/lexer/yaral.rb`) so the gem entrypoint correctly loads the lexer from its canonical path (`lib/rouge/lexers/yaral.rb`)

- Lexing of UDM fields

## [0.1.1] - 2026-03-05

- Failed attempt fixing gem loading

## [0.1.0] - 2026-03-05

### Added

#### Language registration

- Tag `yaral` with aliases `yara-l` and `chronicle`
- File extensions `*.yaral` and `*.yara-l`
- MIME type `text/x-yaral`
- Auto-detection heuristics: matches `rule Name {`, `events:`, `match:`, `outcome:`, and `condition:` patterns

#### Keywords

- Rule structure: `rule`, `meta`, `events`, `match`, `outcome`, `condition`, `options`
- Logical operators: `and`, `or`, `not`, `nocase`, `in`
- Window operators: `over`, `by`, `before`, `after`
- Boolean literals: `true`, `false`
- Search query operators: `select`, `unselect`, `dedup`, `order`, `limit`, `asc`, `desc`
- Quantifiers: `any`, `all`, `of`
- Control flow: `if`, `else`
- Data sources: `udm`, `graph`

#### Time unit keywords

- `day`, `hour`, `minute`, `week`, `month`, `year`

#### Aggregation functions

- `count`, `count_distinct`, `sum`, `avg`, `min`, `max`, `stddev`
- `array`, `array_distinct`

#### Evaluation functions

- `arrays.concat`, `arrays.index_to_float`, `arrays.index_to_int`, `arrays.index_to_str`,
  `arrays.join_string`, `arrays.length`, `arrays.max`, `arrays.min`, `arrays.size`
- `bytes.to_base64`
- `cast.as_bool`, `cast.as_float`, `cast.as_string`
- `group`
- `hash.fingerprint2011`, `hash.sha256`
- `math.abs`, `math.ceil`, `math.floor`, `math.geo_distance`, `math.is_increasing`,
  `math.log`, `math.pow`, `math.random`, `math.round`, `math.sqrt`
- `net.ip_in_range_cidr`
- `optimization.sample_rate`
- `re.capture`, `re.capture_all`, `re.regex`, `re.replace`
- `strings.base64_decode`, `strings.coalesce`, `strings.concat`, `strings.contains`,
  `strings.count_substrings`, `strings.ends_with`, `strings.extract_domain`,
  `strings.extract_hostname`, `strings.from_base64`, `strings.from_hex`,
  `strings.ltrim`, `strings.reverse`, `strings.rtrim`, `strings.split`,
  `strings.to_lower`, `strings.to_upper`, `strings.trim`, `strings.url_decode`
- `timestamp.as_unix_seconds`, `timestamp.current_seconds`, `timestamp.get_date`,
  `timestamp.get_day_of_week`, `timestamp.get_hour`, `timestamp.get_minute`,
  `timestamp.get_timestamp`, `timestamp.get_week`, `timestamp.now`
- `window.avg`, `window.first`, `window.last`, `window.median`,
  `window.mode`, `window.range`, `window.stddev`, `window.variance`

#### Token types

- Single-line comments (`// ...`)
- Multi-line comments (`/* ... */`)
- Double-quoted strings with escape sequences
- Backtick strings (raw, no escape processing)
- Regex literals (`/pattern/`)
- Integer and float number literals
- Duration literals (`5m`, `1h`, `24h`, `1d`, `10s`) tokenized as integer + time unit
- Reference list variables (`%list_name`) as `Name::Variable::Global`
- Count references (`#event_name`) as `Name::Variable::Instance`
- Rule names as `Name::Class`
- UDM field paths (dotted identifiers) as `Name::Property`
- Comparison and arithmetic operators
