# Llm Client

Ruby client to connect to [LLM Server](https://github.com/mariochavez/llm_server).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add llm_client

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install llm_client

## Usage

To start using the gem host configuration is need it. The host value is the URL where the LLM Server is running.

```ruby
LlmClient.host = "http://localhost:9292"
```

Optionally you can configure a Ruby Logger and log level.

```ruby
LlmClient.logger = Logger.new(STDOUT)
LlmClient.log_level = LlmClient::LEVEL_DEBUG
```

Valid log levels are:
- `LlmClient::LEVEL_DEBUG`
- `LlmClient::LEVEL_ERROR`
- `LlmClient::LEVEL_INFO`

With configuration ready, you can start by checking that the LLM Server is up and running.

```ruby
result = LlmClient.heartbeat

if result.success?
  puts "Server is running"
  response = result.success
  puts "Status: #{response.status}"
  puts "Body: #{response.body}"
  puts "Headers: #{response.headers}"
else
  puts "Server is not responding"
  error = result.failure
  puts "Error: #{error}"
end
```

Next, you can send a prompt to be completed by the LLM Server.

```ruby
response = LlmClient.completion("Who is the creator of Ruby language?")
if result.success?
  puts "Completions generated successfully"
  response = result.success
  puts "Status: #{response.status}"
  puts "Body: #{response.body}"
  puts "Headers: #{response.headers}"
  calculated_response = response.body[:response]
  puts "Calculated Response: #{calculated_response}"
else
  puts "Failed to generate completions"
  error = result.failure
  puts "Error: #{error}"
end
```

The response in both cases is a `Result` monad that wraps a `Response` struct.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mariochavez/llm_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mariochavez/llm_client/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/mariochavez/llm_client/blob/main/LICENSE.txt).

## Code of Conduct

Everyone interacting in the LlmClient project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mariochavez/llm_client/blob/main/CODE_OF_CONDUCT.md).
