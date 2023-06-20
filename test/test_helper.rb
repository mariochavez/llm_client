# frozen_string_literal: true

ENV["RUBY_NEXT_TRANSPILE_MODE"] = "rewrite"
ENV["RUBY_NEXT_EDGE"] = "1"
ENV["RUBY_NEXT_PROPOSED"] = "1"
require "ruby-next/language/runtime" unless ENV["CI"]

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "llm_client"

require "minitest/autorun"
