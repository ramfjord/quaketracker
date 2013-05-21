class GeocoderCompatibility < ActiveRecord::Migration
  def change
    rename_column :quakes, :lat, :latitude
    rename_column :quakes, :lon, :longitude
    add_column :quakes, :address, :string # does an earthquake have a useful address?
  end
end
