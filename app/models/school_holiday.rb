class SchoolHoliday < ActiveRecord::Base

  belongs_to :school

  before_save :set_end_date_as_start_date, :unless => :end_date

  attr_accessible :start_date, :end_date, :name

  validates_presence_of :name
  validates_date :start_date
  validates_date :end_date, :allow_nil => true

  default_scope order('start_date asc')

  def school_year
    school.school_year(start_date)
  end

  private

  def set_end_date_as_start_date
    self.end_date = start_date unless end_date.present?
  end

end
