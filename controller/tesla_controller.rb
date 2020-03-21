require "./config/environment"
require "./models/user.rb"
require "./models/car.rb"
require "./models/my_superchargers.rb"
require "geocoder"

class TeslaController < Sinatra::Base

    @location = {}

    configure do
		set :views, "./views"
		enable :sessions
        set :session_secret, "password_security"
        Geocoder::Configuration.timeout = 15
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
            @collection = Car.where(user: session[:user_id])
            erb :account
        end
    end

    post '/account/my_chargers' do
        @@my_chargers = MySuperchargers.where(user_id: session[:user_id])
        erb :my_chargers
    end

    post '/account/new_charger' do
        erb :new_charger
    end

    post '/account/add_charger' do
        if params[:name] == "" || params[:street] == "" || params[:city] == "" || params[:country] == "" || params[:stalls] == "" || params[:power] == ""
            erb :new_charger
        else
            address = "#{params[:street]}, #{params[:city]}, #{params[:state]}, #{params[:zip]}, #{params[:country]}"
            coordinates = Geocoder.coordinates(address)
            if coordinates == nil
                redirect to "/account"
            else
                params[:user_id] = session[:user_id]
                params[:stalls] = params[:stalls].to_i
                params[:power] = params[:power].to_i
                params[:latitude] = coordinates[0]
                params[:longitude] = coordinates[1]
                new_charger = MySuperchargers.new(params)
                new_charger.save
                redirect to "/account"
            end
        end
    end

    post '/account/charger/edit' do
        if params[:user_id].to_i == session[:user_id]
            @@charger = MySuperchargers.find(params[:id].to_i)
            erb :edit_charger
        else
            redirect to '/'
        end
    end

    post '/account/charger/update' do
        @@charger = MySuperchargers.find(params[:id].to_i)
        if params[:name] == "" || params[:street] == "" || params[:city] == "" || params[:country] == "" || params[:stalls] == "" || params[:power] == ""
            erb :edit_charger
        else
            if params[:user_id].to_i == session[:user_id]
                address = "#{params[:street]}, #{params[:city]}, #{params[:state]}, #{params[:zip]}, #{params[:country]}"
                coordinates = Geocoder.coordinates(address)
                if coordinates == nil
                    erb :edit_charger
                else
                    @@charger.name = params[:name]
                    @@charger.street = params[:street]
                    @@charger.city = params[:city]
                    @@charger.state = params[:state]
                    @@charger.zip = params[:zip]
                    @@charger.country = params[:country]
                    @@charger.stalls = params[:stalls]
                    @@charger.power = params[:power]
                    @@charger.latitude = coordinates[0]
                    @@charger.longitude = coordinates[1]
                    if @@charger.save
                        redirect to '/account'
                    else
                        erb :edit_charger
                    end
                end
            else
                redirect to '/'
            end
        end
    end

    post '/account/charger/delete' do
        if params[:user_id].to_i == session[:user_id]
            MySuperchargers.find(params[:id].to_i).destroy
            redirect to '/account'
        else
            redirect to '/'
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
        if session[:user_id] == nil
            redirect to '/'
        else
            if params[:start] == "" || params[:destination] == ""
                redirect to "/account"
            else
                car = Car.where(user: session[:user_id]).last
                if car != nil
                    params[:model] = car.model
                    params[:range] = car.range
                    coordinates = SearchCoordinates.new.coor(params[:start],params[:destination])
                    params[:start_coor] = coordinates[0]
                    params[:end_coor] = coordinates[1]
                    @@planned_route = RoutePlanner.new.geo(coordinates,car.range.to_i)
                    erb :route
                else
                    redirect to '/tesla_collection/shop'
                end
            end
        end
    end

    get '/account/tesla_collection' do
        if session[:user_id] == nil
            redirect to '/'
        else
            @collection = Car.where(user: session[:user_id])
            erb :tesla_collection
        end
    end

    get '/tesla_collection/shop' do
        redirect to '/' if session[:user_id] == nil
        erb :shop if session[:user_id] != nil
    end

    post '/account/tesla_collection' do
        if session[:user_id] == nil
            redirect to '/'
        else
            if params[:user].to_i == session[:user_id]
                params[:user] = session[:user_id]
                car = Car.new(params)
                if car.save
                    redirect to '/account'
                else
                    redirect to '/tesla_collection/shop'
                end
            else
                redirect to '/'
            end
        end
    end

    post '/account/sell_car' do
        if session[:user_id] == nil
            redirect to '/'
        else
            Car.where(user: session[:user_id]).destroy_all
            redirect to '/account'
        end
    end

    post '/logout' do
        session.clear
        redirect to '/'
    end 
end