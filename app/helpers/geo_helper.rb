module GeoHelper
  def self.radians(n)
    n * Math::PI / 180
  end

  def self.distance(lat1, lon1, lat2, lon2)
    radius = 6371 # in KM
    dLat = radians (lat2-lat1)
    dLon = radians (lon2-lon1)
    lat1 = radians lat1
    lat2 = radians lat2

    # taken from http://andrew.hedges.name/experiments/haversine/
    # haversine method - already a little inaccurate because it doesn't take into account 
    # the spherical shape of the earth, but also a bit off with the example calculation.
    # It should still be reasonably accurate for our purposes though
    a = Math.sin(dLat/2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon/2)**2 
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    radius * c
  end
end
