class SearchCoordinates
    def coor(start, destination)
        start_coordinates = Geocoder.coordinates(start)
        destinaion_coordinates = Geocoder.coordinates(destination)
        binding.pry
        coordinates = [start_coordinates,destinaion_coordinates]
    end
end