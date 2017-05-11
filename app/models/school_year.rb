class SchoolYear < ActiveRecord::Base

  belongs_to :school
  has_many :scheduled_domains, :dependent => :destroy
  has_many :domain_maps, :dependent => :destroy

  validates_presence_of :start_date, :end_date

  attr_accessible :start_date, :end_date, :name
  attr_accessor :months, :weeks

  serialize :schedule, JSON

  def self.year_for_school_and_date(school, date)
    where('school_id = ? and start_date < ? and end_date > ?', school.id, date, date).first || school.school_years.first
  end

  def copy_from(from, opts)
    grade = opts[:grade]
    include_lesson_plans = opts[:include_lesson_plans]
    scheduled_domains.where(:grade => grade).delete_all
    from.scheduled_domains.where(:grade => grade).map do |sd|
      new_sd = scheduled_domains.new.tap do |new_sd|
        new_sd.grade = grade
        new_sd.subject_id = sd.subject_id
        new_sd.domain_id = sd.domain_id
        new_sd.start_week = sd.start_week
        new_sd.days = sd.days
        new_sd.school_id = school_id
      end
      new_sd.save
      new_sd
    end.uniq { |sd| sd.domain_id }.each do |sd|
      domain_maps.where(:domain_id => sd.domain_id).delete_all
      from_dm = from.domain_maps.where(:domain_id => sd.domain_id).first
      if from_dm
        new_dm = from_dm.dup.tap do |dm|
          dm.school_year_id = id
        end
        new_dm.save
        if include_lesson_plans
          from_dm.domain_units.all.each do |from_du|
            new_du = from_du.dup.tap do |du|
              du.domain_map_id = new_dm.id
            end
            new_du.save
            from_du.lesson_plans.each do |from_lp|
              new_lp = from_lp.dup.tap do |lp|
                lp.domain_unit_id = new_du.id
              end
              new_lp.save
              from_lp.lesson_plan_files.each do |from_lpf|
                from_lpf.dup.tap do |lpf|
                  lpf.lesson_plan_id = new_lp.id
                end.save
              end
            end
          end
        end
      end
    end   
  end

  def school_holidays(start_date = self.start_date, end_date = self.end_date)
    school.school_holidays.where('(school_holidays.start_date > ? and school_holidays.start_date < ?) or (school_holidays.end_date > ? and school_holidays.end_date < ?)', start_date, end_date, start_date, end_date)
  end

  def months
    @months ||= assign_months
    @weeks ||= assign_weeks
    @months
  end

  def weeks
    @months ||= assign_months
    @weeks ||= assign_weeks
  end

  def short_form
    "#{ start_date.year }-#{ end_date.year }"
  end

  def name
    read_attribute(:name).blank? ? short_form : read_attribute(:name)
  end

  def days_count
    count = (weeks.count - 2) * 5
    count += first_week_days_count + last_week_days_count
    count - school_holidays.count    
  end

  def days_count_before(end_date)
    @months ||= assign_months
    weeks = assign_weeks(end_date)
    count = (weeks.count - 2) * 5
    count += first_week_days_count + last_week_days_count(end_date)
    count - school_holidays(start_date, end_date).count
  end

  def starting_schedule_day(start_date)
    schedule[days_count_before(end_date) % schedule.size]
  end

  def first_week_days_count
    5 - start_date.days_to_week_start
  end

  def last_week_days_count(end_date = self.end_date)
    1 + end_date.days_to_week_start
  end

  class Month

    attr_reader :start_date, :end_date, :number
    attr_accessor :weeks

    def initialize(start_date, end_date)
      @start_date, @end_date, @weeks, @number = start_date, end_date, [], start_date.month
    end

    def name
      @name ||= Date::MONTHNAMES[number]
    end
  end

  class Week

    attr_reader :school_year, :start_date, :end_date, :month, :index

    def initialize(school_year, start_date, end_date, month, index)
      @school_year, @start_date, @end_date, @month, @index = school_year, start_date, end_date, month, index
    end

    def short_form
      "#{ @start_date.strftime('%b %d, %Y') } - #{ @end_date.strftime('%b %d, %Y') }"
    end

    def micro_form
      "#{ @start_date.strftime('%b %d') }-#{ @end_date.strftime('%b %d') }"
    end

    def holidays(all_holidays = nil)
      if all_holidays
        all_holidays.select { |h| (h.start_date >= start_date && h.start_date <= end_date) || (h.end_date >= start_date && h.end_date <= end_date) }
      else
        school.school_holidays.where(['(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', start_date, end_date, start_date, end_date])
      end
    end

    def next_week
      school_year.weeks.find {|w| w.index == index + 1}
    end

    def holidays_text
      holidays.map do |holiday|
        "#{ holiday.name }: #{ holiday.start_date.strftime('%b %d') }"
      end.join("<br/>")
    end

    private

    def school
      school_year.school
    end

  end

  private

  def assign_months(end_date = self.end_date)
    months, start = [], start_date
    while start < end_date
      months << Month.new(start == start_date ? start : start.beginning_of_month,
                           start.end_of_month >= end_date ? end_date : start.end_of_month)
      start = start.beginning_of_month + 1.month
    end
    months
  end

  def assign_weeks(end_date = self.end_date)
    weeks, start, index = [], start_date, 1
    while start <= end_date
      unless holidays.find {|h| h.start_date <= start.beginning_of_week && h.end_date >= start.end_of_week}
        month = @months.find {|m| m.number == start.month}
        new_week = Week.new(self,
          (start == start_date ? start : start.beginning_of_week),
          (start.end_of_week >= end_date ? end_date : start.end_of_week),
          month,
          index)
        weeks << new_week
        month.weeks << new_week
        index += 1
      end
      start = start + 1.week
    end
    @months = @months.reject {|m| m.weeks.empty?}
    weeks
  end

  def holidays
    @holidays ||= school.school_holidays
  end

end
