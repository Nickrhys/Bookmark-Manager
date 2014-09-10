require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require './lib/link' # this needs to be done after datamapper is initialised
require './lib/tag'
require './lib/user'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'

enable :sessions
set :session_secret, 'my unique encryprtion key!'
use Rack::Flash

get '/' do
	@links = Link.all 
	erb :index
end

post '/links' do 
	url= params["url"]
	title = params["title"]
	tags = params["tags"].split(" ").map{|tag|Tag.first_or_create(:text => tag)}
	Link.create(:url => url, :title => title, :tags => tags)
	redirect to ('/')
end

get '/tags/:text' do 
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new'  do
	@user = User.new
	erb :"users/new"
end

	get '/sessions/new' do
		erb :"sessions/new"
	end

	post '/sessions' do
		email, password = params[:email], params[:password]
		user = User.authenticate(email, password)
		if user
			session[:user_id] = user.id
			redirect to('/')
		else
			flash[:errors] = ["The email or password is incorrect"]
			erb :"sessions/new"
		end
	end
	
post '/users'  do
	@user = User.new(:email => params[:email],
					:password => params[:password],
					:password_confirmation => params[:password_confirmation])
		
	if @user.save
		session[:user_id] = @user.id
		redirect to('/')
		# if it's not valid
		# we'll show the same
		# form again
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :"users/new"
	end


end
