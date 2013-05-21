require 'rake'
require 'net/http'
require 'csv'
 
namespace :quakes do
  desc "Initialize the earthquakes by adding them all to the database"
  task :init => :environment do
    p "Connecting to server earthquake.usgs.gov"
    Net::HTTP.start("earthquake.usgs.gov") do |http|
      p "Getting latest earthquake data"
      resp = http.get("/earthquakes/catalogs/eqs7day-M1.txt")

      p "processing earthquake data and loading into database"
      csv = CSV.parse(resp.body)

      headers = csv.shift.map(&:downcase)
      csv.each do |line|
        Quake.from_csv(headers, line).save
      end
    end
  end
end
