namespace :mtbf do
  desc "Prints out MTBF reports"
  task report: :environment do
    puts "MTBF for all machines: #{Machine.mtbf}"
    puts "MTBF for all machines, first six months: #{Machine.mtbf(Time.new(2014,1,1,00,00,0), Time.new(2014,5,31,23,59,59))}"
    puts "MTBF for all machines, last six months: #{Machine.mtbf(Time.new(2014,6,1,00,00,0), Time.new(2014,12,31,23,59,59))}"
    puts "MTBF for machines with ids 1 through 5: #{Machine.mtbf(nil, nil, [1,2,3,4,5])}"
    puts "MTBF for machines with ids 1 through 5, last 3 months: #{Machine.mtbf(Time.new(2014,10,1,00,00,0), Time.new(2014,12,31,23,59,59), [1,2,3,4,5])}"
  end

end
