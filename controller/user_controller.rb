class UserController < TeslaController

    configure do
		set :views, "./views"
		enable :sessions
        set :session_secret, "password_security"
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
            @collection = Car.where(user: session[:user_id])
            erb :account
        end
    end

    post '/logout' do
        session.clear
        redirect to '/'
    end 


end