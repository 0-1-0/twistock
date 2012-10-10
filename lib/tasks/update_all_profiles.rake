require 'rake'

desc "Update all profiles in system"
task :update_all_profiles => :environment do
  print 'performing jobs... '
  User.update_all_profiles
  puts 'done'
end