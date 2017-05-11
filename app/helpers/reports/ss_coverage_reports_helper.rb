module Reports::SsCoverageReportsHelper

  def cells_for_node(node, report, school, pdf)
    cells = [[node.name_with_prefix, nil, nil, nil, nil]]
    node.guidelines.for_school(school).each do |guideline|
      if report.guideline_covered?(guideline) && report.include_covered?
        report.domains_for(guideline).sort {|a,b| report.start_week_for(a) <=> report.start_week_for(b)}.each_with_index do |domain, i|
          cells << [i == 0 ? pdf.make_cell(:content => guideline.name.gsub("&nbsp;", " "), :inline_format => true) : "", "Y", domain.name, domain.grade, report.start_week_for(domain)]
        end
      elsif report.include_uncovered? && !report.guideline_covered?(guideline)
        cells << [pdf.make_cell(:content => guideline.name.gsub("&nbsp;", " "), :inline_format => true), "X", nil, nil, nil]
      end
    end
    node.children.order('position asc').each do |child| 
      cells += cells_for_node(child, report, school, pdf)
    end
    cells
  end
    
end
