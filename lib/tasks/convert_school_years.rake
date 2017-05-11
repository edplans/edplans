namespace :edplans do
  desc "Convert from singular school years to multiple school years"
  task :school_years => :environment do
    School.find_each do |school|
      school.school_years.create :start_date => school.year_start, :end_date => school.year_end
    end
  end
  
  desc "Convert scheduled domains to school year based"
  task :scheduled_domain_school_years => :environment do
    ScheduledDomain.find_each do |sd|
      sd.school_year = sd.school.school_year
      sd.save
    end
  end

  desc "Conver domain maps to school year based"
  task :domain_map_school_years => :environment do
    DomainMap.where(:school_year_id => nil).find_each do |dm|
      dm.school_year_id = dm.school.school_year.id
      dm.save
    end
  end
end
