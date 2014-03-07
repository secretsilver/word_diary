require 'sinatra/base'
require 'omniauth-twitter'
require_relative 'worddiary/dictionary'
require 'dotenv'
Dotenv.load

# Wordnik config
Wordnik.configure do |config|
  config.api_key = ENV['WORDNIK_API_KEY'] 
end


class WordDiary < Sinatra::Base
  enable :sessions

  use OmniAuth::Builder do
    provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
  end

  helpers do
    def user?
      session[:user]
    end
  end

	get '/' do
    erb :index, :layout => false
	end

  get '/login' do
    redirect to("/auth/twitter")
  end

  get '/logout' do
    session[:admin] = nil
    erb :index, :layout => false
  end

  get '/auth/twitter/callback' do
    env['omniauth.auth'] ? session[:user] = true : halt(401, "Not Authorized")
    erb :home
  end

  get '/auth/failure' do
    params[:message]
  end

	get '/define' do
		@word = params[:word]
		dictionary = Dictionary.new
		@definitions = dictionary.define_word(@word)
		erb :define
	end

	# $0 is the executed file
	# __FILE__ is the current file
	run! if __FILE__ == $0
end
