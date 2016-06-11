require 'rubygems'
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-twitter'
require 'mongoid'
require './signatory'

require 'dotenv'
Dotenv.load

Mongoid.load!('mongoid.yml')

BASE_URL = ENV['BASE_URL'] || 'http://localhost:9292'

configure do
  set :sessions, true
  set :inline_templates, true
  set :root, File.dirname(__FILE__)
end

use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
end
  
get '/' do
  erb :index
end
  
get '/auth/:provider/callback' do
  # Get omniauth data
  auth_data = request.env['omniauth.auth']
  session[:user] = "#{auth_data['provider']}:#{auth_data['uid']}"
  # Store signature
  if Signatory.find_by(:twitter_id => auth_data['uid']).nil?
    s = Signatory.create( 
      :twitter_id   => auth_data['uid'],
      :name         => auth_data['info']['name'],
      :nickname     => auth_data['info']['nickname'],    
      :image        => auth_data['info']['image'],
    )
  end

  # Redirect to signed page
  redirect '/signed'
end
  
get '/auth/failure' do
  erb :auth_failed
end
  
get '/auth/:provider/deauthorized' do
  erb :deauthorized
end
  
get '/signed' do
  redirect '/' and return unless session[:user]
  @count = Signatory.count
  erb :signed
end

get '/signatories' do
  @count = Signatory.count
  @signatories = Signatory.all.reverse
  erb :signatories, layout: false
end

get '/count' do
  @count = Signatory.count
  erb :count, layout: false
end
