module QuakesHelper
  def latitude
    "#{@latitude}&deg N".html_safe
  end

  def longitude
    "#{@longitude}&deg E".html_safe
  end

  def map_at(lat, lon)
    [ "http://maps.googleapis.com/maps/api/staticmap?",
      "center=#{lat},#{lon}&",
      "markers=color:green%7Clabel:G%7C#{lat},#{lon}&",
      "zoom=5&",
      "size=640x400&",
      "scale=1&",
      "maptype=terrain&",
      "sensor=#{!@from_user.nil?}" ].join("")
  end
end
