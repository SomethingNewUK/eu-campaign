require 'rubygems'
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-facebook'
require 'mongoid'
require './signatory'

require 'dotenv'
Dotenv.load

Mongoid.load!('mongoid.yml')

BASE_URL = ENV['BASE_URL'] || 'http://localhost:9292/'

configure do
  set :sessions, true
  set :session_secret, SecureRandom.hex(32)
  set :inline_templates, true
  set :root, File.dirname(__FILE__)
end

use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET'], {secure_image_url: true}
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], {secure_image_url: true, image_size: {width: 48, height: 48}}
end
  
get '/' do
  erb :index
end
  
get '/auth/:provider/callback' do
  # Get omniauth data
  auth_data = request.env['omniauth.auth']
  session[:user] = "#{auth_data['provider']}:#{auth_data['uid']}"
  case auth_data['provider']
  when "twitter"
    Signatory.create_or_update_from_twitter(auth_data)
  when "facebook"
    Signatory.create_or_update_from_facebook(auth_data)
  else
    raise "oh dear, unknown provider #{auth_data['provider']}"
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
