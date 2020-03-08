class Location
    attr_accessor :city, :state, :zip
    def address
        html = HTTParty.get("https://gps-coordinates.org/what-city-am-i-in.php")
        data = Nokogiri::HTML(html)
        address = data.css("div address").text
        binding.pry
    end
end