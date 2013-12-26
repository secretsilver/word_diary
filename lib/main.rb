require 'sinatra/base'
require_relative 'dictionary'

class Main < Sinatra::Base
	get '/:word' do
		word = params[:word]
		dictionary = Dictionary.new

		definition = dictionary.define(word)
		"#{word.capitalize}: #{definition}"
	end

	# $0 is the executed file
	# __FILE__ is the current file
	run! if __FILE__ == $0
end
