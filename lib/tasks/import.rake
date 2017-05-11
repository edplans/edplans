# encoding: UTF-8

require 'csv'

desc "Import CSV Curriculum"
task :import => :environment do

  subject_area, current_category, current_lesson,
  current_grade_level, current_unit, current_topic = nil

  CSV.read(File.join(Rails.root, 'doc', 'kindergarten.csv'), :headers => true).each do |row|
    unless row["Subject Area"].blank?
      subject_area = SubjectArea.common.find_or_create_by_name(row["Subject Area"])
      p subject_area.name
    end
    unless row["Grade Level"].blank?
      current_category = current_grade_level = subject_area.categories.find_or_create_by_name(subject_area.name + " - " + row["Grade Level"].gsub(/^\w*\. /, ""))
      p current_grade_level.name
    end
    unless row["Unit"].blank?
      current_category = current_unit = current_grade_level.children.find_or_create_by_name(row["Unit"].gsub(/^\w*\. /, ""))
      p current_unit.name
    end
    unless row["Topic"].blank?
      current_category = current_topic = current_unit.children.find_or_create_by_name(row["Topic"].gsub(/^\w*\. /, ""))
      p current_topic.name
    end
    unless row["Guideline"].blank?
      if current_unit.children.empty?
        current_unit.update_attribute :skip_next_level, true
        current_lesson = current_unit.lessons.find_or_create_by_name(row["Guideline"].gsub(/^\W*/, ""))
      else
        current_lesson = current_topic.lessons.find_or_create_by_name(row["Guideline"].gsub(/^\W*/, ""))
      end
      p current_lesson.name
    end
    unless row["Notes"].blank?
      current_category.update_attribute(:tips, row["Notes"])
    end
    unless row["Sub-Guideline"].blank?
      current_lesson.lesson_body ||= ""
      current_lesson.update_attribute(:lesson_body, current_lesson.lesson_body << row["Sub-Guideline"] << "\n")
    end
  end

end
