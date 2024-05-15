class Api::ChatGptUsecase < Api::Usecase
	class Input < Api::Usecase::Input
		attr_accessor :prompt

		def initialize(prompt:)
			@prompt = prompt
		end
	end

	class Output < Api::Usecase::Output
		attr_accessor :response

		def initialize(response:)
			@response = response
		end
	end

	def initialize(input:)
		@input = input
	end

	def fetch
		openai = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
		begin
			response = openai.chat(
				parameters: {
					model: "gpt-3.5-turbo",
					messages: [{ role: "system", content: "You are a helpful assistant. response to japanese" }, { role: "user", content: @input.prompt }],
					temperature: 0.7,
					max_tokens: 200,
				}
			)
			result = response['choices'].first['message']['content']
			Output.new(response: result)
		rescue => e
			Rails.logger.error "Failed to fetch response from OpenAI: #{e.message}"
			Output.new(response: "Error fetching response")
		end
	end	
end
