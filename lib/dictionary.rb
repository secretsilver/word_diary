%w( rubygems wordnik ).each { |lib| require lib }

class Dictionary

	# def initialize(word)
	# 	base_url = 'https://api.wordnik.com'
	# 	url = "#{base_url}/v4/resources.json"
	# end

	Wordnik.configure do |config|
		config.api_key = ENV['WORDNIK_API_KEY'] 
	end

	def define_word(word)
		definition = Wordnik.word.get_definitions(word)
		
		definition.collect do |word|
			word["text"].to_s
		end
	end
end
