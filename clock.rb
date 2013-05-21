require 'clockwork'
include Clockwork

handler do |job|
    puts "Running #{job}"
end

every(60.seconds, `rake quakes:update`)
