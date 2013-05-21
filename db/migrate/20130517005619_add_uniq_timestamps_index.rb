class AddUniqTimestampsIndex < ActiveRecord::Migration
  def change
    add_index :quakes, [:datetime, :lat, :lon], :unique => true, :name => 'quake_spacetime_uniqueness_index'
  end
end
