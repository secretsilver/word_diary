%w( rubygems wordnik ).each { |lib| require lib }

class Dictionary

	# def initialize(word)
	# 	base_url = 'https://api.wordnik.com'
	# 	url = "#{base_url}/v4/resources.json"
	# end

	Wordnik.configure do |config|
		config.api_key = '58ad9ba8136909b00a00c015f6e0d9c4c577583004a097d4c'
	end

	def define(word)
		a = Wordnik.word.get_definitions(word)
		a[0]["text"].to_s
	end
end
