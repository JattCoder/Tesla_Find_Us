require "./config/environment"
require "./models/user.rb"
require "./models/car.rb"
require "geocoder"
#require "./app/models/user" Here i will have cars and users models class where active record will be used
class TeslaController < Sinatra::Base

    configure do
		set :views, "./views"
		enable :sessions
		set :session_secret, "password_security"
	end

    get '/' do
        session.clear #Temporary till logout button is designed.
        if session[:user_id] == nil
            erb :homepage
        else
            redirect to '/account'
        end
    end

    get '/register' do
        erb :register
    end

    post '/register' do
        if params[:name] == "" || params[:username] == "" || params[:password] == ""
			redirect to "/register"
        else
            user = User.new(params)
            user.save
            session[:user_id] = user.id
			redirect to "/account"
		end
    end

    post '/login' do
        if params[:email] == "" || params[:password] == ""
            redirect to "/"
        else
            @user = User.find_by(email: params[:email])
     	    if @user && @user.authenticate(params[:password])
       		    session[:user_id] = @user.id
			    redirect to "/account"
     	    else
			    redirect to "/"
     	    end
        end
    end

    get '/account' do
        #get all of my saved cars
        if session[:user_id] == nil
            redirect to "/"
        else
            result = request.location
            @user = User.find_by(id: session[:user_id])
            erb :account
        end
    end

    get '/logout' do
        session.clear
    end 
end