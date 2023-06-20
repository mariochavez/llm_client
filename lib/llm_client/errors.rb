# frozen_string_literal: true

module LlmClient
  # Custom error class for connection-related errors in LLM client.
  #
  # This class inherits from the StandardError class and can be raised when there is an error in the connection to the LLM server.
  #
  class ConnectionError < StandardError
    attr_reader :original_error

    # Initialize a new ConnectionError object with an error message and the original error.
    #
    # Parameters:
    #   message - A String representing the error message.
    #   original_error - The original error object that caused the connection error.
    #
    # Returns a new ConnectionError object.
    #
    def initialize(message, original_error)
      super(message)
      @original_error = original_error
    end
  end
end
