namespace "edplans" do
  desc "Create an admin user"
  task :admin, [:email] => :environment do |t, args|
    User.new.tap do |u|
      u.email = args[:email]
      u.admin = true
      u.password = "ckpasspleasechange"
    end.save
  end
end
