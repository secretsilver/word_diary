require 'sinatra/base'

class Main < Sinatra::Base
	get '/' do
		'Diction Harry in the House YOO!'
	end

	# $0 is the executed file
	# __FILE__ is the current file
	run! if __FILE__ == $0
end
