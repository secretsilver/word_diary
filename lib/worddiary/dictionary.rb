%w( rubygems wordnik ).each { |lib| require lib }

class Dictionary

	Wordnik.configure do |config|
		config.api_key = ENV['WORDNIK_API_KEY'] 
	end

	def define_word(word)
		definition = Wordnik.word.get_definitions(word)
    puts definition 
      definition.collect { |w| w["text"].to_s } 
	end
end
