require 'geocoder'
class Address 

    def initialize(from,to,car)
        address1 = Geocoder.address(from)
        address2 = Geocoder.address(to)
        address(address1,address2,car)
    end

    def address(address1,address2,car)
        add1url = address1.split(" ").join("%20")
        add1coor = Geocoder.coordinates(address1)
        add2url = address2.split(" ").join("%20")
        add2coor = Geocoder.coordinates(address2)
        url = "https://www.tesla.com/trips#/?v=#{car}&o=#{add1url}_#{add1url}@#{add1coor[0]},#{add1coor[1]}&s=&d=#{add2url}_#{add2url}@#{add2coor[0]},#{add2coor[1]}"
        
    end

    def chargerlist(url)

    end
end