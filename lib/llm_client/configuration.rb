# frozen_string_literal: true

module LlmClient
  # The Configuration class allows you to configure the connection settings for the LlmClient.
  # It can be initialized directly calling #new method.
  #
  # Examples
  #
  #   configuration = LlmClient::Configuration.new
  #   configurarion.host = "http://localhost:9292"
  #
  # Or via a setup block.
  #
  # Examples
  #
  #   LlmClient::Configuration.setup do |config|
  #     config.host = "https://localhost:9292"
  #   end
  class Configuration
    # Sets the host name for the Llm.
    #
    # Examples
    #
    #   config.host = "chroma.example.com"
    #
    # Returns the String host name.
    attr_accessor :host

    # Sets the logger for the LlmClient.
    #
    # Examples
    #
    #   config.logger = Logger.new(STDOUT)
    #
    # Returns the Logger instance.
    attr_accessor :logger

    # Sets the logger's log level for the LlmClient.
    #
    # Examples
    #
    #   config.log_level = LlmClient::LEVEL_INFO
    #
    # Returns the log level constant
    attr_accessor :log_level

    def self.setup
      new.tap do |instance|
        yield(instance) if block_given?
      end
    end

    def initialize
      @log_level = LlmClient::LEVEL_INFO
    end
  end
end
