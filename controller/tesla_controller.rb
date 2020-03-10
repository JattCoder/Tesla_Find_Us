require "./config/environment"
require "./models/user.rb"
require "./models/car.rb"
require "geocoder"

class TeslaController < Sinatra::Base

    configure do
		set :views, "./views"
		enable :sessions
		set :session_secret, "password_security"
	end

    get '/' do
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
            if user.save
                session[:user_id] = user.id
                redirect to "/account"
            else
                redirect to "/"
            end
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
        if session[:user_id] == nil
            redirect to "/"
        else
            result = request.location
            @user = User.find_by(id: session[:user_id])
            erb :account
        end
    end

    post '/account/search' do
        if session[:user_id] == nil
            redirect to '/'
        elsif params[:nearmeh] == ""
            redirect to "/account"
        else
            location = Location.new
            @@nearme = location.find(params[:nearmeh])
            erb :nearme
        end
    end

    post '/account/route-planner' do
        if params[:start] == "" || params[:destination] == ""
            redirect to "/account"
        else
            planned_route = Address.new(params[:start],params[:destination])
            #check if location is full address, city, zip, state
            #or scrape location name from tesla web and and get details from location class 
            erb :route
        end
    end

    post '/logout' do
        session.clear
        redirect to '/'
    end 
end