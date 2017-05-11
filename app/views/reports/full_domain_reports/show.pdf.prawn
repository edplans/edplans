prawn_document(:page_layout => :landscape) do |pdf|

  pdf.text "#{ @report.school.name } #{ @report.school_year.short_form }", :size => 16
  pdf.text "School-Wide Curriculum Report", :size => 16


  @report.months.each do |month|
    pdf.move_down 20
    pdf.text month.name, :size => 14

    table = []
    pdf.font_size 9

    column_width = 640 / @report.grades.size

    table << ["Week"] + @report.grades.map {|g| School.grade_name_for(g)}
    month.weeks.each do |week|
      table << ["#{ week.index }\n#{ week.short_form }"] + @report.grades.map do |grade|
        scheduled_domains = @report.scheduled_domains_for_grade_and_week(grade, week)
        if scheduled_domains.empty?
          ""
        else
          subtable = scheduled_domains.map do |sd|
            text = if sd.domain.is_course_unit?
                     "<i>#{ sd.domain.name }</i>"
                   elsif sd.domain.is_custom?
                     "<u>#{ sd.domain.name }</u>"
                   else
                     sd.domain.name
                   end
            if week.index == sd.start_week
              [pdf.make_cell(:content => "#{ text } (#{ pluralize(sd.weeks, 'Week') })", :inline_format => true)]
            elsif week == month.weeks.first
              [pdf.make_cell(:content => "#{ text } (Continued)", :inline_format => true)]
            end
          end.compact
          pdf.make_table subtable, :column_widths => column_width unless subtable.empty?
        end
      end
    end
    pdf.table table, :column_widths => Hash.new(column_width).merge({0 => 60}), :header => true

  end

  render :partial => 'reports/key', :locals => { :pdf => pdf }

  render :partial => 'reports/footer', :locals => { :pdf => pdf }

end
