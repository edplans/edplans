class SchoolHolidayDecorator < ApplicationDecorator

  decorates :school_holiday

  def as_json(opts = {})
    { :start => model.start_date,
      :title => model.name }
  end

end
