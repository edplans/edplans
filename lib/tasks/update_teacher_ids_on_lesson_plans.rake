namespace :edplans do
  desc "Update Teacher IDs on Lesson Plans"
  task :update_teacher_ids => :environment do
    LessonPlan.all.each do |lp|
      if lp.domain_unit
        lp.update_attribute :teacher_id, lp.domain_unit.teacher_id
      else
        lp.destroy
      end
    end
  end
end
  
