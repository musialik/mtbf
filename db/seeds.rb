Defect.delete_all

year_start = Time.new(2014,1,1,00,00,0)
year_end = Time.new(2014,12,31,23,59,59)
number_of_machines = 10
min_defect_time = 1.hour
max_defect_time = 10.hours
number_of_defects = 10

puts "Generating defects..."

number_of_defects.times do |i|
  started_at = rand(year_start..year_end)
  finished_at = started_at + rand(min_defect_time..max_defect_time)

  Defect.create(
    started_at: started_at, 
    finished_at: finished_at, 
    machine_id: rand(number_of_machines)
  )

  print "#{i+1}, "
end

puts "Done!"