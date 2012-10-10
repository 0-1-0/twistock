require 'rake'

task :update_users => :environment do

  counter = 0

  puts 'Updating potentially bad users with hour_delta_price > 1000'
  User.where('hour_delta_price > 1000').each do |user|
    old_delta = user.hour_delta_price
    user.update_share_price
    new_delta = user.hour_delta_price

    if old_delta != new_delta
      counter += 1
    end
    
    puts '.'
  end
  puts 'OK'
  puts 'cured', counter, 'users'


  counter = 0


  puts 'Updating potentially bad users with hour_delta_price < -1000'
  User.where('hour_delta_price < -1000').each do |user|
    old_delta = user.hour_delta_price
    user.update_share_price
    new_delta = user.hour_delta_price

    if old_delta != new_delta
      counter += 1
    end


    puts '.'
  end
  puts 'OK'
  puts 'cured', counter, 'users'

end

