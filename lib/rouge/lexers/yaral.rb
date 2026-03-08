# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class YARAL < RegexLexer
      title 'YARA-L'
      desc 'YARA-L 2.0 language for Google Security Operations'
      tag 'yaral'
      aliases 'yara-l', 'chronicle'
      filenames '*.yaral', '*.yara-l'
      mimetypes 'text/x-yaral'

      def self.detect?(text)
        return true if text =~ /^\s*rule\s+\w+\s*\{/m
        return true if text =~ /\bevents\s*:/
        return true if text =~ /\bmatch\s*:/
        return true if text =~ /\boutcome\s*:/
        return true if text =~ /\bcondition\s*:/
      end

      def self.keywords
        @keywords ||= Set.new %w(
          rule meta events match outcome condition options
          and or not nocase in over by
          before after true false
          select unselect dedup order limit
          asc desc
          any all of
          cidr regex
          if else
          udm graph
          left right join outer every
          stage
        )
      end

      def self.keywords_time
        @keywords_time ||= Set.new %w(
          day hour minute week month year
        )
      end

      def self.aggregation_functions
        @aggregation_functions ||= Set.new %w(
          count count_distinct sum avg min max stddev
          array array_distinct
          earliest latest
        )
      end

      def self.builtin_functions
        @builtin_functions ||= Set.new %w(
          arrays.concat arrays.index_to_float arrays.index_to_int
          arrays.index_to_str arrays.join_string arrays.length
          arrays.max arrays.min arrays.size
          bytes.to_base64
          cast.as_bool cast.as_float cast.as_int cast.as_string
          group
          hash.fingerprint2011 hash.sha256
          math.abs math.ceil math.floor math.geo_distance
          math.is_increasing math.log math.pow math.random
          math.round math.sqrt
          metrics.alert_event_name_count
          metrics.auth_attempts_fail metrics.auth_attempts_success
          metrics.auth_attempts_total
          metrics.dns_bytes_outbound
          metrics.dns_queries_fail metrics.dns_queries_success
          metrics.dns_queries_total
          metrics.file_executions_fail metrics.file_executions_success
          metrics.file_executions_total
          metrics.http_queries_fail metrics.http_queries_success
          metrics.http_queries_total
          metrics.network_bytes_inbound metrics.network_bytes_outbound
          metrics.network_bytes_total
          metrics.resource_creation_success metrics.resource_creation_total
          metrics.resource_deletion_success
          metrics.resource_read_fail metrics.resource_read_success
          net.ip_in_range_cidr
          optimization.sample_rate
          re.regex re.capture re.capture_all re.replace
          strings.base64_decode strings.coalesce strings.concat
          strings.contains strings.count_substrings strings.ends_with
          strings.extract_domain strings.extract_hostname
          strings.from_base64 strings.from_hex
          strings.ltrim strings.reverse strings.rtrim
          strings.split strings.to_lower strings.to_upper strings.trim
          strings.url_decode
          timestamp.as_unix_seconds timestamp.current_seconds
          timestamp.get_date timestamp.get_minute
          timestamp.get_hour timestamp.get_day_of_week
          timestamp.get_timestamp timestamp.get_week
          timestamp.now
          window.avg window.first window.last window.median
          window.mode window.range window.stddev window.variance
        )
      end

      def self.function_namespaces
        @function_namespaces ||= Set.new %w(
          arrays bytes cast hash math metrics net optimization
          re strings timestamp window
        )
      end

      state :root do
        rule %r/\s+/m, Text::Whitespace
        rule %r(//.*$), Comment::Single
        rule %r(/\*), Comment::Multiline, :multiline_comment

        # Section headers (meta:, events:, match:, outcome:, condition:, options:)
        rule %r/(meta|events|match|outcome|condition|options|select|unselect|dedup|order|limit)(\s*)(:)/ do
          groups Keyword, Text::Whitespace, Punctuation
        end

        # Rule declaration
        rule %r/(rule)(\s+)(\w+)(\s*)(\{)/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Class, Text::Whitespace, Punctuation
        end

        # Duration literals: 5m, 1h, 1d, 10m, 24h, etc.
        rule %r/\b(\d+)\s*(m|h|d|s)\b/ do
          groups Num::Integer, Keyword::Type
        end

        # Strings
        rule %r/"/, Str::Double, :double_string
        rule %r/`/, Str::Backtick, :backtick_string

        # Regex literals
        rule %r(/), Str::Regex, :regex

        # Reference list variables %name
        rule %r/%[a-zA-Z_]\w*/, Name::Variable::Global

        # Count references #name
        rule %r/#[a-zA-Z_]\w*/, Name::Variable::Instance

        # Numbers
        rule %r/\b\d+\.\d+\b/, Num::Float
        rule %r/\b\d+\b/, Num::Integer

        # Namespaced function calls (strings.concat, re.regex, etc.)
        rule %r/\b[a-zA-Z_]\w*\.[a-zA-Z_]\w*(?=\s*\()/ do |m|
          if self.class.builtin_functions.include? m[0]
            token Name::Builtin
          else
            token Name::Function
          end
        end

        # Variable with UDM path and map access: $e.additional.fields["key"]
        rule %r/(\$\w+)((?:\.\w+)+)(\[)("(?:[^"\\]|\\.)*")(\])/ do |m|
          token Name::Variable, m[1]
          token Name::Attribute, m[2]
          token Punctuation, m[3]
          token Str::Double, m[4]
          token Punctuation, m[5]
        end

        # Variable with UDM path: $e.metadata.event_type
        rule %r/(\$\w+)((?:\.\w+)+)/ do |m|
          token Name::Variable, m[1]
          token Name::Attribute, m[2]
        end

        # Standalone variable: $user, $host
        rule %r/\$\w+/, Name::Variable

        # UDM field paths: sequences like principal.hostname, metadata.event_type
        # Distinguished from keywords by the dot path
        rule %r/\b[a-zA-Z_]\w*(?:\.[a-zA-Z_]\w*)+\b/ do |m|
          # Check if it's a namespaced function used without parens
          if self.class.builtin_functions.include? m[0]
            token Name::Builtin
          else
            token Name::Property
          end
        end

        # Operators
        rule %r/[!=<>]=?/, Operator
        rule %r/[+\-*]/, Operator

        # Punctuation
        rule %r/[{}()\[\]:;,.]/, Punctuation

        # Words: keywords, functions, or identifiers
        rule %r/\b\w+\b/ do |m|
          if self.class.keywords.include? m[0].downcase
            token Keyword
          elsif self.class.keywords_time.include? m[0].downcase
            token Keyword::Type
          elsif self.class.aggregation_functions.include?(m[0].downcase) ||
                self.class.function_namespaces.include?(m[0].downcase)
            token Name::Builtin
          else
            token Name
          end
        end
      end

      state :multiline_comment do
        rule %r([^*/]+), Comment::Multiline
        rule %r(/\*), Comment::Multiline, :multiline_comment
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([*/]), Comment::Multiline
      end

      state :double_string do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end

      state :backtick_string do
        rule %r/[^`]+/, Str::Backtick
        rule %r/`/, Str::Backtick, :pop!
      end

      state :regex do
        rule %r([^/\\]+), Str::Regex
        rule %r(\\.),     Str::Regex
        rule %r(/),       Str::Regex, :pop!
      end
    end
  end
end
