prawn_document(:page_layout => :landscape) do |pdf|

  pdf.text "#{ @report.school.name } - #{ @report.school_year.short_form }", :size => 16
  pdf.text "CK Sequence Planning Report", :size => 16
  pdf.text @report.subject.name, :size => 16

  pdf.move_down 20

  table = []
  table << ["Sequence Content", "Planned?", "Domains & Topics", "Domain Grade Level", "Start Week"]

  @report.grades.each do |grade|
    table << [School.grade_name_for(grade), nil, nil, nil, nil]
    unless @report.subject.children_for_grade(grade).blank?
      @report.subject.children_for_grade(grade).each do |child| 
        table += cells_for_node(child, @report, @school, pdf)
      end
    end
  end

  pdf.table table, :column_widths => { 1 => 60 }, :header => true

  render :partial => 'reports/key', :locals => { :pdf => pdf }

  render :partial => 'reports/footer', :locals => { :pdf => pdf }

end
