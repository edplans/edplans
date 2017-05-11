prawn_document do |pdf|

  pdf.text "#{ @report.school.name } #{ @report.school_year.short_form }", :size => 16
  pdf.text "Weekly Plan", :size => 16

  pdf.move_down 10
  
  @report.weeks.each do |week|
    pdf.move_down 10
    table = []
    table << [pdf.make_cell(:content => "<font size='14'>Week #{ week.index }</font>: #{ week.short_form }", :inline_format => true)]
    @report.school.grades.each do |grade|
      unless @report.domains_for_grade_and_week(grade, week).empty?
        table << [pdf.make_cell(:content => "<b>#{ School.grade_name_for(grade) }</b>", :inline_format => true)]
        @report.domains_for_grade_and_week(grade, week).uniq.each do |domain|
          table << [render(:partial => 'reports/domain', :locals => { :domain => domain, :pdf => pdf })]
        end
      end
    end
    pdf.table table
  end

  render :partial => 'reports/key', :locals => { :pdf => pdf }

  render :partial => 'reports/footer', :locals => { :pdf => pdf }

end
