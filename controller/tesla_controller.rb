require "./config/environment"
#require "./app/models/user" Here i will have cars and users models class where active record will be used
class TeslaController < Sinatra::Base

    get '/' do
        "<h1>Hello World to everyone</h1>"
    end
end
