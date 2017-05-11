class RelatedKnowledgeReport < ReportBase

  report_attrs :teacher, :grade, :domain

  def school
    @school ||= teacher.school
  end

  def prior_knowledge
    knowledge_connections.map(&:prior_knowledge).compact.uniq.sort_by {|c| [c.grade.to_i, c.position]}
  end

  def cross_knowledge
    knowledge_connections.map(&:cross_knowledge).compact.uniq.sort_by {|c| [c.grade.to_i, c.position]}
  end

  def future_knowledge
    knowledge_connections.map(&:future_knowledge).compact.uniq.sort_by {|c| [c.grade.to_i, c.position]}
  end

  private

  def knowledge_connections
    KnowledgeConnection.where(:guideline_id => guideline_ids).includes(:prior_knowledge).includes(:future_knowledge)
  end

  def guideline_ids
    @guideline_ids ||= domain_maps.map(&:guideline_ids).flatten.uniq
  end

  def domain_maps
    @domain_maps ||= school.domain_maps.where(:domain_id => domain.id)
  end

end
