namespace :edplans do
  desc "Set grade on all standards"
  task :standard_grades => :environment do
    Standard.all.each do |s|
      s.send :set_grade
      s.save
    end
  end
end
