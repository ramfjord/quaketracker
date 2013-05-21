require 'rake'
# http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
require 'net/http'
require 'csv'

 
namespace :quakes do
  desc "Update the Earthquakes table to reflect the most current earthquake data"
  task :update => :environment do

    last_quake = Quake.first # default order is descending time
    time_cutoff = nil

    if last_quake.nil?
      time_cutoff = Time.at(0)
      p "Getting all the earthquakes we can"
    else
      time_cutoff = last_quake.datetime
      p "Getting earthquakes since #{time_cutoff}"
    end


    p "Connecting to server earthquake.usgs.gov"
    Net::HTTP.start("earthquake.usgs.gov") do |http|
      p "Getting latest earthquake data"
      resp = http.get("/earthquakes/catalogs/eqs7day-M1.txt")

      p "processing earthquake data and loading into database"
      csv = CSV.parse(resp.body)
      Quake.update_from_csv(csv)
    end
  end
end
