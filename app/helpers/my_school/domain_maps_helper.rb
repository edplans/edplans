module MySchool::DomainMapsHelper

  def highlight_if_domain_applicable(node, domain)
    "applicable" if node.domain_applications.any? {|a| a.domain_id == domain.id}
  end

  def mapped_if_guideline_mapped(guideline, domain_map)
    "mapped" if domain_map.guideline_ids.include?(guideline.id) || 
      domain_map.skills_guideline_ids.include?(guideline.id)
  end

end
