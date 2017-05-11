class DomainLessonsReport < ReportBase

  report_attrs :teacher, :grade, :domain, :school_year_id

  def school
    @school ||= teacher.school
  end

  def school_year
    @school_year ||= school.school_years.find(school_year_id)
  end

  def curriculum_nodes_for(domain_map)
    CurriculumNode.where(:id => domain_map.guidelines.map(&:curriculum_node_id))
  end

  def guidelines_for(curriculum_node, domain_map)
    domain_map.guidelines.select {|g| g.curriculum_node_id == curriculum_node.id}
  end

  def domain_units_for(domain_map)
    school.domain_units.for_domain_map(domain_map)
  end

  def lesson_plans_for_domain_map_and_guideline(domain_map, guideline)
    domain_units_for(domain_map).map(&:lesson_plans).flatten.select {|l| l.includes_guideline?(guideline)}
  end

  def domain_maps
    @domain_maps ||= school_year.domain_maps.where(:domain_id => domain.id)
  end

end
