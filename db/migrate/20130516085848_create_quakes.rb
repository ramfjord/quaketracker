class CreateQuakes < ActiveRecord::Migration
  def change
    create_table :quakes do |t|
      # Src 
      # ak
      t.string :src
      
      # Eqid
      # 10717982 OR b000gwvx
      t.string :eqid
      
      # Version
      # 1
      t.integer :version

      # Datetime
      # "Thursday May 16  2013 07:55:21 UTC"
      t.datetime :datetime
        
      #  Lat
      # 59.9753 
      t.float :lat
      
      # Lon
      # 59.9753
      t.float :lon
      
      # Magnitude
      # 1.5 
      t.float :magnitude
      
      # Depth
      # 19.20
      t.float :depth

      # NST 
      # 8 
      t.integer :nst
      
      # Region
      # "Southeastern Alaska"
      t.string :region
    end
  end
end
