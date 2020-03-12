require 'geocoder'
class RoutePlanner
    
    def geo(address1,address2)
        arr = []
        add1coor = Geocoder.coordinates(address1)
        add2coor = Geocoder.coordinates(address2)
        totaldistance = Geocoder::Calculations.distance_between(add1coor,add2coor)
        return arr << "Can not plan a route with given address." if totaldistance == nil
        chargers = Location.new
        #cars = Car.new.all
        car = 250 #temporary till car class is done
        route = findroute(add1coor,add2coor,totaldistance,chargers.all,car)
        route
    end

    def findroute(start,destination,totaldistance,schargers,car)
        add1 = Geocoder.address(start).split(", ")
        add2 = Geocoder.address(destination).split(", ")
        stops = []
        battery = []
        if car > totaldistance
            return stops << "No need to make a stop for charging"
        end
        #grab supercharger
        #get its location and check if it shortens the distance to destination
        #get the distance from start to supercharger
        #check if the car can cover the distance from start to supercharger
        #if car can not cover it then skip that supercharger
        #if car can cover it then
            #
        superchargerid = ""
        while totaldistance >= 0
            schargers.each do |charger|
                binding.pry
                dist_between_charger_destination = Geocoder::Calculations.distance_between(destination,[charger["gps"]["latitude"],charger["gps"]["longitude"]])
                if dist_between_charger_destination == nil
                    #skip charger
                elsif dist_between_charger_destination < totaldistance
                    dist_between_start_charger = Geocoder::Calculations.distance_between(start,[charger["gps"]["latitude"],charger["gps"]["longitude"]])
                    if dist_between_start_charger < (car - 50)
                        good = is_it_good()
                        if good == true
                            stops << charger["locationId"]
                            battery << (car - dist_between_start_charger)
                            start = [charger["gps"]["latitude"],charger["gps"]["longitude"]]
                            totaldistance = totaldistance - dist_between_start_charger
                        end
                    end
                end
            end
        end
        binding.pry
    end

    def is_it_good
        #here i need to check if i can make it to next charger and skip the first charger to save time
        #car range, allchargers, selectedchargerid, start, destination, totaldistance
    end
end