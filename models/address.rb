require 'geocoder'
class Address

    def initialize
        @tries = 0
    end

    def address(from,to)    
        address1 = Geocoder.address(from)
        address2 = Geocoder.address(to)
        address(address1,address2)
    end

    def geo(address1,address2)
        #car = Car.selected
        car = "M3_2015_74"
        add1url = address1.split(" ").join("%20")
        add1coor = Geocoder.coordinates(address1)
        add2url = address2.split(" ").join("%20")
        add2coor = Geocoder.coordinates(address2)
        url = "https://www.tesla.com/trips#/?v=#{car}&o=#{add1url}_#{add1url}@#{add1coor[0]},#{add1coor[1]}&s=&d=#{add2url}_#{add2url}@#{add2coor[0]},#{add2coor[1]}"
        routeplan(url)
    end

    def routeplan(url)
        generate = HTTParty.get(url)
        parseddata = Nokogiri::HTML.parse(generate)
        binding.pry
    end
end