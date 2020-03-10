require 'geocoder'
class RoutePlanner
    
    def geo(address1,address2)
        add1coor = Geocoder.coordinates(address1)
        add2coor = Geocoder.coordinates(address2)
        totaldistance = Geocoder::Calculations.distance_between(add1coor,add2coor)
        chargers = Location.new
        #cars = Car.new.all
        car = 250 #temporary till car class is done
        route = findroute(add1coor,add2coor,totaldistance,chargers)
        route
    end

    def findroute(start,destination,totaldistance,schargers,car)
        stops = []
        superchargerid = ""
        return Array.new if car > totaldistance
        while totaldistance <= 0
            chargers.each do |charger|
                distance = Geocoder::Calculations.distance_between(distination,[charger["gps"]["latitude"],charger["gps"]["longitude"]])
                if distance < totaldistance
                    distance_covered = totaldistance - distance
                    if distance_covered < (car - 50)
                        superchargerid = charger["locationId"]
                    else
                        stops << superchargerid
                    end
                    totaldistance = totaldistance - distance
                end
            end
        end
    end
end