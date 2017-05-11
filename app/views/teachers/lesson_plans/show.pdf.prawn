prawn_document do |pdf|

  pdf.text @lesson_plan.name, :size => 24
  pdf.move_down 12
  pdf.text "#{ @lesson_plan.teacher.name }               Created on #{ @lesson_plan.created_at.strftime('%b %e, %Y').gsub(/\s+/, ' ') }", :size => 16
  pdf.text "#{ @lesson_plan.domain_unit.domain_map.domain.grade_name }   #{ @lesson_plan.domain_unit.subject.name }   #{ @lesson_plan.domain_unit.domain_map.domain.name }   #{ @lesson_plan.domain_unit.name }", :size => 16
  pdf.move_down 16

  unless @lesson_plan.essential_understanding.blank?
    table = []

    table << [pdf.make_cell(:content => "<b>Essential Understanding</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.essential_understanding.remove_non_pdf_tags, :inline_format => true)]
  
    pdf.table table, :column_widths => { 0 => 200, 1 => 340 }, :cell_style => { :borders => [:top], :padding => 12 }
  end

  unless @lesson_plan.subject_guidelines.empty?
    mo_table = []
    mo_table << [pdf.make_cell(:content => "<b>Subject Guidelines</b>", :inline_format => true), pdf.make_cell(:content => "<b>Guidelines</b>", :inline_format => true), pdf.make_cell(:content => "<b>Details</b>", :inline_format => true), pdf.make_cell(:content => "<b>Measurable Objectives</b>", :inline_format => true)]
    
    @lesson_plan.subject_guidelines.each do |guideline|
      mo_table << [nil, 
                   pdf.make_cell(:content => guideline.name, :inline_format => true, :size => 12), 
                   pdf.make_cell(:content => guideline.sub_guidelines.select {|s| @lesson_plan.sub_guideline_checked?(s)}.map(&:name).map(&:remove_non_pdf_tags).join("\n"), :inline_format => true, :size => 12),
                   pdf.make_cell(:content => @lesson_plan.measurable_objective_for(guideline).remove_non_pdf_tags, :inline_format => true, :size => 12)]
    end
    
    pdf.table mo_table, :column_widths => { 0 => 100, 1 => 100, 2 => 170, 3 => 170 }, :header => true, :cell_style => { :borders => [:top], :padding => 12 }
  end

  unless @lesson_plan.skills_guidelines.empty?
    skills_mo_table = []
    skills_mo_table << [pdf.make_cell(:content => "<b>Skills Guidelines</b>", :inline_format => true), pdf.make_cell(:content => "<b>Guidelines</b>", :inline_format => true), pdf.make_cell(:content => "<b>Details</b>", :inline_format => true), pdf.make_cell(:content => "<b>Measurable Objectives</b>", :inline_format => true)]
    
    @lesson_plan.skills_guidelines.each do |guideline|
      skills_mo_table << [nil, 
                          pdf.make_cell(guideline.name, :inline_format => true, :size => 12), 
                          pdf.make_cell(:content => guideline.sub_guidelines.select {|s| @lesson_plan.sub_guideline_checked?(s)}.map(&:name).map(&:remove_non_pdf_tags).join("\n"), :inline_format => true, :size => 12),
                          pdf.make_cell(:content => @lesson_plan.measurable_objective_for(guideline).remove_non_pdf_tags, :inline_format => true, :size => 12)]
    end
    
    pdf.table skills_mo_table, :column_widths => { 0 => 100, 1 => 100, 2 => 170, 3 => 170 }, :header => true, :cell_style => { :borders => [:top], :padding => 12 } 
  end

  second_table = []

  unless @lesson_plan.ongoing_assessment.blank?
    second_table << [pdf.make_cell(:content => "<b>Assessment</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.ongoing_assessment.remove_non_pdf_tags, :inline_format => true)]
  end
  
  unless @lesson_plan.criteria_for_success.blank?
    second_table << [pdf.make_cell(:content => "<b>Criteria For Success</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.criteria_for_success.remove_non_pdf_tags, :inline_format => true)]
  end

  unless second_table.empty?
    pdf.table second_table, :column_widths => { 0 => 200, 1 => 340 }, :cell_style => { :borders => [:top], :padding => 12 }
  end

  pdf.move_down 16

  pdf.stroke_horizontal_rule
  pdf.move_down 2
  pdf.stroke_horizontal_rule
  pdf.move_down 12

  pdf.text "Activities & Procedures", :size => 16

  pdf.move_down 12

  a_p_table = []

  unless @lesson_plan.read_aloud_resources.blank?
    a_p_table << [pdf.make_cell(:content => "<b>Read-Aloud</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.read_aloud_resources.remove_non_pdf_tags, :inline_format => true)]
  end

  unless @lesson_plan.vocabulary_tier_2_words.blank?
    a_p_table << [pdf.make_cell(:content => "<b>My Vocabulary Words</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.vocabulary_tier_2_words.remove_non_pdf_tags, :inline_format => true)]
  end

  unless @lesson_plan.procedures.blank?
    a_p_table << [pdf.make_cell(:content => "<b>Procedures</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.procedures.remove_non_pdf_tags, :inline_format => true)]
  end
  
  unless @lesson_plan.extensions.blank?
    a_p_table << [pdf.make_cell(:content => "<b>Extensions</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.extensions.remove_non_pdf_tags, :inline_format => true)]
  end

  unless a_p_table.empty?
    pdf.table a_p_table, :column_widths => { 0 => 200, 1 => 340 }, :cell_style => { :borders => [:top], :padding => 12 }
  end

  pdf.move_down 16
  
  pdf.stroke_horizontal_rule
  pdf.move_down 2
  pdf.stroke_horizontal_rule
  pdf.move_down 12

  pdf.text "Additional Information", :size => 16

  pdf.move_down 12

  a_i_table = []

  unless @lesson_plan.support_and_enrichment.blank?
    a_i_table << [pdf.make_cell(:content => "<b>Support and Enrichment</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.support_and_enrichment.remove_non_pdf_tags, :inline_format => true)]
  end

  unless @lesson_plan.materials_and_resources.blank?
    a_i_table << [pdf.make_cell(:content => "<b>Materials and Resources</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.materials_and_resources.remove_non_pdf_tags, :inline_format => true)]
  end

  if current_user == @lesson_plan.teacher
    unless @lesson_plan.personal_notes.blank?
      a_i_table << [pdf.make_cell(:content => "<b>Personal Notes</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.personal_notes.remove_non_pdf_tags, :inline_format => true)]
    end
  end

  unless @lesson_plan.team_notes.blank?
    a_i_table << [pdf.make_cell(:content => "<b>Creator's Notes to Other Users</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.team_notes.remove_non_pdf_tags, :inline_format => true)]
  end

  unless @lesson_plan.public_notes.blank?
    a_i_table << [pdf.make_cell(:content => "<b>Public Notes</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.public_notes.remove_non_pdf_tags, :inline_format => true)]
  end

#  unless @lesson_plan.lesson_plan_files.empty?
    a_i_table << [pdf.make_cell(:content => "<b>Attached Files</b>", :inline_format => true), pdf.make_cell(:content => @lesson_plan.lesson_plan_files.map(&:attachment_file_name).join("\n"), :inline_format => true)]
#  end

  unless a_i_table.empty?
    pdf.table a_i_table, :column_widths => { 0 => 200, 1 => 340 }, :cell_style => { :borders => [:top], :padding => 12 }
  end

  pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 25], :width  => pdf.bounds.width do
    pdf.stroke_horizontal_rule
    pdf.move_down(5)
    pdf.text t('reports.footer.copyright'), :size => 10
  end
  
end
