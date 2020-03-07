require "./config/environment"
require "./models/user.rb"
#require "./app/models/user" Here i will have cars and users models class where active record will be used
class TeslaController < Sinatra::Base

    configure do
		set :views, "./views"
		enable :sessions
		set :session_secret, "password_security"
	end

    get '/' do
        erb :homepage
    end

    get '/register' do
        erb :register
    end

    post '/register' do
        if params[:name] == "" || params[:username] == "" || params[:password] == ""
			redirect to "/register"
        else
            binding.pry
            user = User.new(params[:name],params[:email],params[:password])
            #user = User.create(:name => params[:name], :username => params[:email], :password => params[:password])
            binding.pry
			redirect to "/"
		end
    end

    post '/login' do
        if params[:email] == "" || params[:password] == ""
            redirect to "/"
        else
            @user = User.find_by(username: params[:username])
     	    if @user && @user.authenticate(params[:password])
       		    session[:user_id] = @user.id
			    redirect to "/account"
     	    else
			    redirect to "/"
     	    end
        end
    end

    get '/account' do
        #scrape geo location to show
        #get all of my saved cars
        if logged_in

        else
            redirect to "/"
        end
    end
end