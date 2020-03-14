require 'geocoder'
class RoutePlanner
    
    def geo(coordinates,car)
        arr = []
        add1coor = "#{coordinates[0][0]},#{coordinates[0][1]}" #add1coor.split(",")[0].to_f
        add2coor = "#{coordinates[1][0]},#{coordinates[1][1]}"
        totaldistance = dist_cal(coordinates[0],coordinates[1])
        return arr << "Can not plan a route with given address." if totaldistance == nil
        return arr << "No Need to make a stop for charing." if totaldistance < car
        chargers = Location.new
        route = findroute(add1coor,add2coor,(totaldistance - (car * 0.45)),chargers.all,car)
        route
    end

    def findroute(start,destination,totaldistance,schargers,car)
        planned_route = {}
        while totaldistance >= 0
            schargers.each do |charger|
                start_points = [start.split(",")[0].to_f,start.split(",")[1].to_f]
                dest_points = [destination.split(",")[0].to_f,destination.split(",")[1].to_f]
                dis_charger_dest = dist_cal([charger["gps"]["latitude"],charger["gps"]["longitude"]],dest_points)
                dis_charger_strt = dist_cal([charger["gps"]["latitude"],charger["gps"]["longitude"]],start_points)
                if dis_charger_dest < totaldistance && dis_charger_strt.between?(car*0.45, car*0.65)
                    #good = confirmed(schargers,((car * 0.65) - dis_charger_strt),"#{charger["gps"]["latitude"]},#{charger["gps"]["longitude"]}",destination,(totaldistance - dis_charger_strt))
                    battery = (((dis_charger_strt / car) * 100) - 100) * (-1)
                    planned_route[charger["locationId"]] = {
                        "locationId" => charger["locationId"],
                        "name" => charger["name"],
                        "street" => charger["address"]["street"],
                        "city" => charger["address"]["city"],
                        "state" => charger["address"]["state"],
                        "zip" => charger["address"]["zip"],
                        "country" => charger["address"]["country"],
                        "chargers" => charger["stallCount"],
                        "power" => charger["powerKilowatt"],
                        "battery" => battery
                    }
                    totaldistance = totaldistance - dis_charger_strt
                    start = "#{charger["gps"]["latitude"]},#{charger["gps"]["longitude"]}"
                end
            end
        end
        planned_route
    end

    def confirmed(schargers,range,start,destination,totaldistance)
        schargers.each do |charger|
            charger_points = [start.split(",")[0].to_f,start.split(",")[1].to_f]
            destination_points = [destination.split(",")[0].to_f,destination.split(",")[1].to_f]
            distination_charger_dest = dist_cal([charger["gps"]["latitude"],charger["gps"]["longitude"]],destination_points)
            distination_strt_next_charger = dist_cal([charger["gps"]["latitude"],charger["gps"]["longitude"]],charger_points)
            if distination_charger_dest < totaldistance && distination_strt_next_charger.between?(0, range)
                false
            else
                true
            end
        end
    end

    def dist_cal(a, b)
        rad_per_deg = Math::PI/180  # PI / 180
        rkm = 6371                  # Earth radius in kilometers
        rm = rkm * 1000             # Radius in meters
      
        dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
        dlat_rad = (b[0]-a[0]) * rad_per_deg
      
        lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
        lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }
      
        a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
        c = 2 * Math.asin(Math.sqrt(a))
      
        meters = rm * c # Delta in meters
        kilometers = meters / 1000
        miles = meters * 0.000621
        #if country == "United States of America" || country == "United Kingdom" || country == "Gibraltar"
        #    miles.round(2)
        #else
        #    kilometers.round(2)
        #end
        miles.round(2)
      end
end