# frozen_string_literal: true

module LlmClient
  # Request's response Data object.
  #
  # status - HTTP status code. It is zero when a request fails due to network error.
  # body - Parsed JSON object or response body.
  # headers - HTTP response headers.
  # error - Exception if the response is not success
  Response = Struct.new("Response", :status, :body, :headers, :error)

  # Request class to perform HTTP requests.
  class HttpClient
    using RubyNext
    include Dry::Monads[:result]

    # Sends a heartbeat request to the LLM Server.
    #
    # This method is used to check the status of the LLM Server.
    #
    # Returns a dry-monad Result object, which can be a Success or Failure.
    # If the server is running and responds successfully, a Success Result is returned.
    # If there's an error or the server is not responding, a Failure Result is returned.
    #
    # Examples
    #
    #   result = heartbeat
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
    # Notes
    #
    #   - Make sure the LLM Server is running before calling this method.
    #
    def heartbeat
      url = "#{LlmClient.host}/heartbeat"
      Util.log_debug("Sending a request", method: :GET, url:)

      response = HTTP.get(url)

      if response.status.success?
        Util.log_info("Successful response", status: response.status)
        Success(build_response(response))
      else
        Util.log_info("Unsuccessful response", status: response.status)
        Failure(build_response(response))
      end
    rescue => exception
      Util.log_info("heartbeat error", error: exception.message)

      error = LlmClient::ConnectionError.new("heartbeat error", exception)
      Failure(Response.new(status: 0, body: error.message, headers: {}, error:))
    end

    # Public: Sends a completion request to the LLM Server.
    #
    # This method is used to generate completions based on a given prompt using the LLM Server.
    #
    # Parameters:
    #   prompt - A String representing the prompt for which completions should be generated.
    #
    # Returns a dry-monad Result object, which can be a Success or Failure.
    # If the completion request is successful, a Success Result is returned.
    # If there's an error or the server fails to generate completions, a Failure Result is returned.
    #
    # Examples
    #
    #   result = completion("Hello, world!")
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
    # Notes
    #
    #   - Make sure the LLM Server is running before calling this method.
    #
    def completion(prompt)
      url = "#{LlmClient.host}/completion"
      Util.log_debug("Sending a request", method: :POST, url:)

      response = HTTP.headers(
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      ).post(url, json: {prompt:})

      if response.status.success?
        Util.log_info("Successful response", status: response.status)
        Success(build_response(response, parse: true))
      else
        Util.log_info("Unsuccessful response", status: response.status)
        Failure(build_response(response))
      end
    rescue => exception
      Util.log_info("prompt error", error: exception.message)

      error = LlmClient::ConnectionError.new("prompt error", exception)
      Failure(Response.new(status: 0, body: error.message, headers: {}, error:))
    end

    private

    def build_response(response, parse: false)
      Response.new(
        status: response.status,
        body: parse ? parse_json(response.body.to_s) : response.body.to_s,
        headers: response.headers.to_h,
        error: nil
      )
    end

    def parse_json(content)
      JSON.parse(content, symbolize_keys: true)
    rescue JSON::ParserError, TypeError
      content
    end
  end
end
