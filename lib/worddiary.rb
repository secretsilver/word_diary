require 'sinatra/base'
require 'sinatra/activerecord'
require 'omniauth-twitter'
require_relative 'worddiary/dictionary'
require 'dotenv'
Dotenv.load

# Wordnik config
Wordnik.configure do |config|
  config.api_key = ENV['WORDNIK_API_KEY'] 
end

# Models:
class User < ActiveRecord::Base
  has_many :dictionary_entries, through: :dictionary_lookups
  has_many :dictionary_lookups
end

class DictionaryEntry < ActiveRecord::Base
  serialize :definitions, Array
end

class DictionaryLookup < ActiveRecord::Base
  belongs_to :user
  belongs_to :dictionary_entry
end


class WordDiary < Sinatra::Base
  enable :sessions
  register Sinatra::ActiveRecordExtension
  set :database, "sqlite3:///words.sqlite3"

  use OmniAuth::Builder do
    provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
  end

  helpers do
    def current_user
      User.find(session[:user_id])
    end

    def user?
      current_user.present?
    end
  end

	get '/' do
    erb :index, :layout => false
	end

  # Btn to get authorized
  get '/login' do
    redirect to("/auth/twitter")
  end

  get '/auth/twitter/callback' do
    session[:user] = true
    puts "SESSION? = #{session[:user]}"
    unless session[:user]
      redirect to("/"), :layout => false
    end

    twitter = env['omniauth.auth']
    # ActiveRelation#first_or_initialize doesn't save the record
    @user = User.find_or_initialize_by_twitter_id(twitter_id: twitter['uid'])
    if @user.new_record?
      @user.save!
    end

    session[:user_id] = @user.id
    puts "SESSION USER ID? = #{session[:user_id]}"
    erb :home
  end

  get '/logout' do
    session[:user] = nil
    erb :index, :layout => false
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/home' do
    if user?
      erb :home
    else
      erb :index, :layout => false
    end
  end

	get '/define' do
    if user?
      @word = params[:word]
      dictionary = Dictionary.new
      @definitions = dictionary.define_word(@word)
      erb :define
    else
      erb :index, :layout => false
    end
  end

  post '/dictionary_entry' do
    @word = params[:word]
    dictionary = Dictionary.new
    @definitions = dictionary.define_word(@word)

    entry = DictionaryEntry.find_or_create_by(word: @word, definitions: @definitions)

    puts "DICTIONARY Word: #{entry.word}"
    puts "DICTIONARY Definition: #{entry.definitions}"

    a = current_user.dictionary_entries << entry
    puts "THIS IS A COLLECTION PROXY? #{a}"

    a.map do |e| 
      puts "THIS IS YOUR DICTIONARY ENTRIES = #{e}"
    end

    erb :home
  end

  get '/diary' do
    # @diary = User.where(id: session[:user_id]).dictionary_entries.map do |item|
    #   item.word
    # end

    @diary = current_user.dictionary_entries.map do |item|
      item.word
    end

    puts "THIS IS MY DIARY: #{@diary}"
    erb :diary
  end

	# $0 is the executed file
	# __FILE__ is the current file
	run! if __FILE__ == $0
end
