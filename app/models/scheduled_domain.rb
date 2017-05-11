class ScheduledDomain < ActiveRecord::Base

  belongs_to :domain
  belongs_to :school
  belongs_to :school_year
  belongs_to :subject, :class_name => "CurriculumNode"

  attr_accessible :domain_id, :subject_id, :grade, :start_week, :days, :school_year_id

  after_destroy :clear_domain_maps

  def domain_name
    @domain_name ||= domain.name
  end

  def domain_is_course_unit?
    @domain_is_course_unit ||= domain.is_course_unit?
  end

  def domain_is_custom?
    @domain_is_custom ||= domain.school_id.present?
  end

  def days
    read_attribute(:days) || domain.days
  end

  def weeks(holidays = nil)
    return 1 if days == 0
    remaining_days = days || 1
    this_week = school_year.weeks.find {|w| w.index == start_week}
    holidays ||= school_year.school_holidays
    return 1 unless this_week
    remaining_days -= 5
    remaining_days += this_week.holidays(holidays).count
    while remaining_days > 0
      if this_week.next_week
        this_week = this_week.next_week
        remaining_days -= 5
        remaining_days += this_week.holidays(holidays).count
      else
        remaining_days = 0
      end
    end
    this_week.index - start_week + 1
  end

  def end_week
    start_week + weeks - 1
  end

  def weeks_taught(holidays = nil)
    end_week = start_week + weeks(holidays) - 1
    (start_week..end_week).to_a
  end

  def taught_in_week?(week, holidays = nil)
    weeks_taught(holidays).include?(week)
  end

  def as_json(opts = {})
    { :id => id, :domain_id => domain_id, :domain_name => domain_name,
      :grade => grade, :start_week => start_week,
      :subject_id => subject_id, :weeks => weeks,
      :domain_is_course_unit => domain_is_course_unit?,
      :weeks_taught => weeks_taught, :days => days,
      :subject_position => subject.position
    }
  end

  private

  def clear_domain_maps
    DomainMap.where(:domain_id => domain_id, :school_id => school_id).find_each do |domain_map|
      domain_map.destroy if domain_map.scheduled_domain.nil?
    end
  end
  
end
