class Quake < ActiveRecord::Base
  $keys = [ "src", "eqid", "datetime", "latitude", "longitude", "magnitude", "depth", "nst", "region" ]
  include GeoHelper

  default_scope order("datetime DESC")

  attr_accessible *$keys

  validates :datetime,  :presence => true, :uniqueness => { :scope => [:latitude, :longitude] }
  validates :latitude,  :presence => true
  validates :longitude, :presence => true
  validates :magnitude, :presence => true

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode

  def self.update_from_csv(csv)
    load_from_csv(csv, true)
  end

  def self.get_all_from_csv(csv)
    load_from_csv(csv, false)
  end

  def self.on(unix_time, quakes = self)
    t = Time.at(unix_time)
    where("datetime > ? AND datetime <= ?",
                 t.beginning_of_day, t.end_of_day)
  end

  def self.since(unix_time, quakes = self)
    time = Time.at(unix_time)
    where("datetime >= ?", time)
  end

  def self.over(magnitude, quakes = self)
    where("magnitude >= ?", magnitude)
  end

  # NOTE this an within unfortunately return an array and not an activerelation -
  # this has to be the last query in the string of them
  def self.near5(lat, lon, quakes = self)
    within(lat,lon,5)
  end

  # quakes within n miles of lat,lon
  def self.within(lat, lon, n) # miles
    box = Geocoder::Calculations.bounding_box([lat, lon], n)
    within_box(*box).keep_if do |e|
      e.within?(lat, lon, n)
    end
  end

  def self.within_box(lat1, lon1, lat2, lon2)
    where("latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?",
          lat1, lon1, lat2, lon2)
  end
  
  def within?(lat, lon, dist)
    GeoHelper.distance(lat, lon, latitude, longitude) <= dist
  end

  def small_json
    to_json(:only => [:datetime, :latitude, :longitude, :magnitude])
  end

  private

  def self.correct_attrs(attrs) # because we import from 2 sources which aren't exactly the same
    attrs['latitude']  = attrs.delete('lat') if(attrs['lat'])
    attrs['longitude'] = attrs.delete('lon') if(attrs['lon'])
    attrs['src'] = attrs.delete('source') if(attrs['source'])

    attrs.each_key do |k|
      attrs.delete k unless $keys.include? k
    end

    attrs
  end
    
  def self.from_csv_line(headers, line)
    attrs = Hash[ headers.zip(line) ]
    self.correct_attrs(attrs)
    return Quake.new(attrs)
  end

  def self.load_from_csv(csv, only_recent)
    time_cutoff = Quake.first.nil? ? Time.at(-9999999999) : Quake.first.datetime
    headers = csv.shift.map(&:downcase)
    added_records = []

    while row = csv.shift do
      q = from_csv_line(headers, row)
      break if (only_recent && q.datetime < time_cutoff)
      if q.save
        p "saved earthquake occuring at #{q.datetime}"
        added_records << q 
      else
        p "skipped earthquake occuring at #{q.datetime}, #{q.latitude}, #{q.longitude}"
      end
    end
    
    added_records
  end
end
