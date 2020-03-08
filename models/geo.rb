require 'geocoder'
class Geo
    def initialize
        location = Geocoder.coordinates("18 de Julio 1234, Montevideo, Uruguay")
        binding.pry
        city = request.location.city
        country = request.location.country_code
    end
end