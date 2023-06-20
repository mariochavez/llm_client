# frozen_string_literal: true

require "http"
require "dry-monads"
require "json"
require "logger"

require "ruby-next"
require "ruby-next/language/setup"

RubyNext::Language.setup_gem_load_path(transpile: true)

require "llm_client/util"
require "llm_client/configuration"
require "llm_client/errors"
require "llm_client/http_client"
require "llm_client/version"

# A module representing an LLM client.
#
# This module provides methods to interact with the LLM Server using an HTTP client.
# It can be configured with a host, a Ruby logger, a log level, and provides methods to forward heartbeat and completion requests to the HTTP client.
#
# Examples
#
#   LlmClient.host = "http://localhost:9292"
#   LlmClient.logger = Logger.new(STDOUT)
#   LlmClient.log_level = LlmClient::LEVEL_DEBUG
#
# If logger is present and log level not set, it is LlmClientL::LEVEL_INFO by default.
#
# After LlmClient module configuration you can interact wiht the LLM Server.
#
# Examples
#
#   result = LlmClient.heartbeat
#   if result.success?
#     puts "Server is running"
#     response = result.success
#     puts "Status: #{response.status}"
#     puts "Body: #{response.body}"
#     puts "Headers: #{response.headers}"
#   else
#     puts "Server is not responding"
#     error = result.failure
#     puts "Error: #{error}"
#   end
#
#   response = LlmClient.completion("Who is the creator of Ruby language?")
#   if result.success?
#     puts "Completions generated successfully"
#     response = result.success
#     puts "Status: #{response.status}"
#     puts "Body: #{response.body}"
#     puts "Headers: #{response.headers}"
#     calculated_response = response.body[:response]
#     puts "Calculated Response: #{calculated_response}"
#   else
#     puts "Failed to generate completions"
#     error = result.failure
#     puts "Error: #{error}"
#   end
#
module LlmClient
  # map to the same values as the standard library's logger
  LEVEL_DEBUG = Logger::DEBUG
  LEVEL_ERROR = Logger::ERROR
  LEVEL_INFO = Logger::INFO

  @config = LlmClient::Configuration.setup
  @http_client = LlmClient::HttpClient.new

  class << self
    extend Forwardable

    attr_reader :config, :http_client

    # User configuration options
    def_delegators :@config, :host, :host=
    def_delegators :@config, :logger, :logger=
    def_delegators :@config, :log_level, :log_level=

    # Http client
    def_delegators :@http_client, :heartbeat, :completion
  end

  LlmClient.log_level = ENV["LLM_CLIENT_LOG"].to_i unless ENV["LLM_CLIENT_LOG"].nil?
end
