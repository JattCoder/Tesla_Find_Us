require "./config/environment"
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

    post '/login' do
        if params[:email] == "" || params[:password] == ""
            redirect to "/"
        else
            erb :account
        end
    end
end