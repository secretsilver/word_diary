require 'sinatra/base'
require_relative 'dictionary'
require 'dotenv'
Dotenv.load

# Wordnik config
Wordnik.configure do |config|
  config.api_key = ENV['WORDNIK_API_KEY'] 
end

class Main < Sinatra::Base

	get '/' do
		erb :home
	end

	get '/:word' do
		@word = params[:word]
		dictionary = Dictionary.new

		@definitions = dictionary.define_word(@word)
		erb :define
	end

	# $0 is the executed file
	# __FILE__ is the current file
	run! if __FILE__ == $0
end
