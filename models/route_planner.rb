require 'geocoder'
class RoutePlanner
    
    def geo(coordinates,car)
        arr = {}
        add1coor = "#{coordinates[0][0]},#{coordinates[0][1]}"
        add2coor = "#{coordinates[1][0]},#{coordinates[1][1]}"
        start_country = Geocoder.address([add1coor.split(",")[0],add1coor.split(",")[1]]).split(", ").last
        dest_country = Geocoder.address([add2coor.split(",")[0],add2coor.split(",")[1]]).split(", ").last
        totaldistance = dist_cal(coordinates[0],coordinates[1],start_country)
        return handle_empty("Can not plan a route with given address") if totaldistance > 3000
        return handle_empty("No Need to make a stop for charging") if totaldistance < (car - 60)
        chargers = Location.new
        route = findroute(add1coor,add2coor,(totaldistance - (car * 0.45)),chargers.all,car,start_country,dest_country)
        route
    end

    def findroute(start,destination,totaldistance,schargers,car,start_country,dest_country)
        planned_route = {}
        while totaldistance >= 0
            schargers.each do |charger|
                start_points = [start.split(",")[0].to_f,start.split(",")[1].to_f]
                dest_points = [destination.split(",")[0].to_f,destination.split(",")[1].to_f]
                dis_charger_dest = dist_cal([charger["gps"]["latitude"],charger["gps"]["longitude"]],dest_points,start_country)
                dis_charger_strt = dist_cal([charger["gps"]["latitude"],charger["gps"]["longitude"]],start_points,start_country)
                #add rules if destination is USA, stops can not be in any other country.
                #if destination is different country, then other country stops can apply
                if dis_charger_dest <= totaldistance && dis_charger_strt.between?(car*0.05, car*0.95)
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
                        "region" => charger["address"]["region"],
                        "battery" => battery
                    }
                    totaldistance = totaldistance - dis_charger_strt
                    start = "#{charger["gps"]["latitude"]},#{charger["gps"]["longitude"]}"
                end
            end
        end
        planned_route
    end

    def dist_cal(a, b, country)
        rad_per_deg = Math::PI/180
        rkm = 6371
        rm = rkm * 1000
        dlon_rad = (b[1]-a[1]) * rad_per_deg
        dlat_rad = (b[0]-a[0]) * rad_per_deg
        lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
        lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }
        a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
        c = 2 * Math.asin(Math.sqrt(a))
        meters = rm * c
        kilometers = meters / 1000
        miles = meters * 0.000621
        miles.round(2)
      end

      def handle_empty(str)
        no_route = {}
        no_route[str] = {
                        "locationId" => str,
                        "name" => str,
                        "street" => "",
                        "city" => "",
                        "state" => "",
                        "zip" => "",
                        "country" => "",
                        "chargers" => "N/A",
                        "power" => "N/A",
                        "region" => "",
                        "battery" => 0
        }
        no_route
      end
end