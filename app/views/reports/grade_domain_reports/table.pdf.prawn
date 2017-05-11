prawn_document do |pdf|
  pdf.text "#{ @report.school.name } - #{ @report.school_year.short_form }", :size => 16
  pdf.text "Grade Level Plan", :size => 16
  pdf.text "Grade: #{ @report.grade }", :size => 16

  table = []
  table << ["Subjects", "Domains & Topics", "Weeks"]
  @report.subjects.each do |subject|
    table << [subject.name, nil, nil]
    @report.domains_for_subject(subject).each do |domain|
      table << [nil, render(:partial => 'reports/domain', :locals => { :domain => domain, :pdf => pdf }), @report.weeks_taught(domain, subject).join(', ')]
    end
  end

  pdf.table table

  render :partial => 'reports/key', :locals => { :pdf => pdf }

  render :partial => 'reports/footer', :locals => { :pdf => pdf }
end
