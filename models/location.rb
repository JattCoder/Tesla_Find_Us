require 'geocoder'
class Location
    
    def initialize
        res = RestClient.get('https://supercharge.info/service/supercharge/sites?draw=3&columns%5B0%5D%5Bdata%5D=name&columns%5B0%5D%5Bname%5D=&columns%5B0%5D%5Bsearchable%5D=true&columns%5B0%5D%5Borderable%5D=true&columns%5B0%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B0%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B1%5D%5Bdata%5D=address.street&columns%5B1%5D%5Bname%5D=&columns%5B1%5D%5Bsearchable%5D=true&columns%5B1%5D%5Borderable%5D=true&columns%5B1%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B1%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B2%5D%5Bdata%5D=address.city&columns%5B2%5D%5Bname%5D=&columns%5B2%5D%5Bsearchable%5D=true&columns%5B2%5D%5Borderable%5D=true&columns%5B2%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B2%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B3%5D%5Bdata%5D=address.state&columns%5B3%5D%5Bname%5D=&columns%5B3%5D%5Bsearchable%5D=true&columns%5B3%5D%5Borderable%5D=true&columns%5B3%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B3%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B4%5D%5Bdata%5D=address.zip&columns%5B4%5D%5Bname%5D=&columns%5B4%5D%5Bsearchable%5D=true&columns%5B4%5D%5Borderable%5D=true&columns%5B4%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B4%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B5%5D%5Bdata%5D=address.country&columns%5B5%5D%5Bname%5D=&columns%5B5%5D%5Bsearchable%5D=true&columns%5B5%5D%5Borderable%5D=true&columns%5B5%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B5%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B6%5D%5Bdata%5D=stallCount&columns%5B6%5D%5Bname%5D=&columns%5B6%5D%5Bsearchable%5D=true&columns%5B6%5D%5Borderable%5D=true&columns%5B6%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B6%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B7%5D%5Bdata%5D=powerKilowatt&columns%5B7%5D%5Bname%5D=&columns%5B7%5D%5Bsearchable%5D=true&columns%5B7%5D%5Borderable%5D=true&columns%5B7%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B7%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B8%5D%5Bdata%5D=function&columns%5B8%5D%5Bname%5D=&columns%5B8%5D%5Bsearchable%5D=true&columns%5B8%5D%5Borderable%5D=true&columns%5B8%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B8%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B9%5D%5Bdata%5D=elevationMeters&columns%5B9%5D%5Bname%5D=&columns%5B9%5D%5Bsearchable%5D=true&columns%5B9%5D%5Borderable%5D=true&columns%5B9%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B9%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B10%5D%5Bdata%5D=function&columns%5B10%5D%5Bname%5D=&columns%5B10%5D%5Bsearchable%5D=true&columns%5B10%5D%5Borderable%5D=true&columns%5B10%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B10%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B11%5D%5Bdata%5D=dateOpened&columns%5B11%5D%5Bname%5D=&columns%5B11%5D%5Bsearchable%5D=true&columns%5B11%5D%5Borderable%5D=true&columns%5B11%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B11%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B12%5D%5Bdata%5D=function&columns%5B12%5D%5Bname%5D=&columns%5B12%5D%5Bsearchable%5D=true&columns%5B12%5D%5Borderable%5D=false&columns%5B12%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B12%5D%5Bsearch%5D%5Bregex%5D=false&order%5B0%5D%5Bcolumn%5D=10&order%5B0%5D%5Bdir%5D=desc&start=0&length=10000&search%5Bvalue%5D=&search%5Bregex%5D=false&regionId=&countryId=&_=1583645074736')
        @res_hash = JSON.parse(res)
        mychargers = MySuperchargers.all
        mychargers.each do |sc|
            hash = {
                "locationId" => "#{sc.name.downcase}supercharger",
                "name" => sc.name,
                "address" => {
                    "street" => sc.street,
                    "city" => sc.city,
                    "state" => sc.state,
                    "zip" => sc.zip,
                    "country" =>sc.country
                },
                "stallCount" => sc.stalls,
                "powerKiloatt" => sc.power,
                "gps" => {
                    "latitude" => sc.latitude.to_f,
                    "longitude" => sc.longitude.to_f
                }
            }
            @res_hash["results"] << hash
        end
    end

    def find(str)
        findcharger = {}
        allstates = []
        strcoor = Geocoder.coordinates(str)
        @res_hash["results"].each do |charger|
            if charger["address"]["city"].to_s.downcase == str.downcase || charger["address"]["zip"].to_s.downcase == str.downcase || charger["address"]["state"].to_s.downcase == str.downcase 
                charger_location = ["#{charger["gps"]["latitude"]}","#{charger["gps"]["longitude"]}"]
                search_location = ["#{strcoor[0]}","#{strcoor[1]}"]
                distance = dist_cal([search_location[0].to_f,search_location[1].to_f],[charger_location[0].to_f,charger_location[1].to_f])
                findcharger[charger["locationId"]] = {
                    "name" => charger["name"],
                    "street" => charger["address"]["street"],
                    "city" => charger["address"]["city"],
                    "state" => charger["address"]["state"],
                    "zip" => charger["address"]["zip"],
                    "stalls" => charger["stallCount"],
                    "power" => charger["powerKilowatt"],
                    "distance" => distance
                }
            end
        end
        return findcharger
    end

    def dist_cal(a, b)
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

    def all
        allchargers = @res_hash["results"]
        allchargers
    end
end