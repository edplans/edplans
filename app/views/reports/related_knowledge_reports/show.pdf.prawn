prawn_document do |pdf|

  pdf.font_families.update "FontAwesome" => {:normal => "#{ Rails.root }/public/fonts/font-awesome/fontawesome-webfont.ttf" }

  pdf.text "#{ @report.school.name } - #{ @report.school.school_year.short_form }", :size => 16
  pdf.text "Prior and Future Knowledge Report", :size => 16
  pdf.text School.grade_name_for(@report.grade), :size => 16 if @report.grade.present?
  pdf.text @report.domain.name, :size => 16

  pdf.move_down 20
  pdf.text "Prior Knowledge", :size => 14

  render :partial => 'knowledge_connection', :collection => @report.prior_knowledge, :locals => { :pdf => pdf }

  pdf.move_down 20

  pdf.text "Future Knowledge", :size => 14
  render :partial => 'knowledge_connection', :collection => @report.future_knowledge, :locals => { :pdf => pdf }

  render :partial => 'reports/footer', :locals => { :pdf => pdf }
end
