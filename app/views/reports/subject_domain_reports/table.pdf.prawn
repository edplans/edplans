prawn_document do |pdf|

  pdf.text "#{ @report.school.name } #{ @report.school_year.short_form }", :size => 16
  pdf.text "Subject-Specific Plan", :size => 16
  pdf.text @report.subject.name, :size => 16

  table = []
  table << ["Grades", "Domains & Topics", "Weeks"]
  @report.grades.each do |grade|
    table << [pdf.make_cell(:content => School.grade_name_for(grade), :size => 14), "", ""]
    @report.domains_for_grade(grade).each do |domain|
      table << ["", render(:partial => 'reports/domain', :locals => { :domain => domain, :pdf => pdf }), @report.weeks_taught(domain, grade).join(', ')]
    end
  end

  pdf.table table, :header => true

  render :partial => 'reports/key', :locals => { :pdf => pdf }

  render :partial => 'reports/footer', :locals => { :pdf => pdf }
end
