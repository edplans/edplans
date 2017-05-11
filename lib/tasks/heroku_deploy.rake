# Via http://stackoverflow.com/a/9425821

# Rake::Task["assets:precompile"].enhance do
#   # How to invoke a task that exists elsewhere
#   # Rake::Task["assets:environment"].invoke if Rake::Task.task_defined?("assets:environment")

#   # Clear cache on deploy
#   unless ENV['MEMCACHIER_USERNAME'].blank?
#     print "Clearing the rails memcached cache\n"
#     Rails.cache.clear
#   end
# end
