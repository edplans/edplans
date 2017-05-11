prawn_document do |pdf|

  pdf.text "#{ @report.school.name } - #{ @report.school_year.short_form }", :size => 16
  pdf.text "Lessons Report", :size => 16

  @report.domain_maps.each do |domain_map|

    pdf.move_down 20
    pdf.text domain_map.domain.name, :size => 14

    table = []
    table << ["Core Knowledge Guideline", "Unit", "Lesson", "Lesson Creator"]
    
    @report.curriculum_nodes_for(domain_map).each do |node|
      table << [node.name_with_prefix, nil, nil, nil]
      
      @report.guidelines_for(node, domain_map).each do |guideline|
        @report.lesson_plans_for_domain_map_and_guideline(domain_map, guideline).each_with_index do |lesson_plan, i|
          
          table << [(i == 0 ? pdf.make_cell(guideline.name, :inline_format => true) : nil), lesson_plan.domain_unit.name, pdf.make_cell(lesson_plan.name, :inline_format => true), lesson_plan.teacher.name]

        end
      end
    end
    
    pdf.table table
  end

  render :partial => 'reports/footer', :locals => { :pdf => pdf }
  
end
