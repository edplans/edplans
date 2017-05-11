class DomainMap < ActiveRecord::Base

  belongs_to :school
  belongs_to :domain
  belongs_to :school_year

  has_many :domain_units, :dependent => :destroy

  attr_accessible :domain_id, :guideline_ids

  serialize :guideline_ids, JSON
  serialize :skills_guideline_ids, JSON
  serialize :included_standard_ids, JSON
  serialize :included_skills_standard_ids, JSON
  serialize :omitted_standard_ids, JSON
  serialize :omitted_skills_standard_ids, JSON
  serialize :vocabulary, JSON
  serialize :omitted_cross_curricular_links, JSON

  def scheduled_domain
    @scheduled_domain ||= ScheduledDomain.where(:domain_id => domain_id, :school_id => school_id).first
  end

  def scheduled_domains
    ScheduledDomain.where(:domain_id => domain_id, :school_id => school_id, :school_year_id => school_year_id).uniq(&:subject_id)
  end

  def start_week
    scheduled_domain.start_week
  end

  def guideline_ids
    read_attribute(:guideline_ids) || []
  end

  def has_guideline?(guideline)
    guideline_ids.include?(guideline.id) || skills_guideline_ids.include?(guideline.id)
  end

  def guidelines
    if guideline_ids.empty?
      []
    else
      Guideline.where(:id => guideline_ids).order('id asc').all
    end
  end

  def add_guideline!(guideline)
    self.guideline_ids = (guideline_ids << guideline.id).uniq
    self.omitted_standard_ids -= guideline.standard_applications.map(&:standard_id)
    save!
  end

  def remove_guideline!(guideline)
    update_attribute :guideline_ids, (guideline_ids - [guideline.id]).uniq
  end

  def skills_guideline_ids
    read_attribute(:skills_guideline_ids) || []
  end

  def skills_guidelines
    if skills_guideline_ids.empty?
      []
    else
      Guideline.where(:id => skills_guideline_ids).order('id asc').all
    end
  end

  def add_skills_guideline!(guideline)
    update_attribute :skills_guideline_ids, (skills_guideline_ids << guideline.id).uniq
  end

  def remove_skills_guideline!(guideline)
    update_attribute :skills_guideline_ids, (skills_guideline_ids - [guideline.id]).uniq
  end

  def included_standard_ids
    read_attribute(:included_standard_ids) || []
  end

  def omitted_standard_ids
    read_attribute(:omitted_standard_ids) || []
  end

  def omit_standard!(standard)
    self.included_standard_ids = (included_standard_ids - [standard.id]).uniq
    self.omitted_standard_ids = (omitted_standard_ids + [standard.id]).uniq
    save!
  end

  def include_standard!(standard)
    self.included_standard_ids = (included_standard_ids + [standard.id]).uniq
    self.omitted_standard_ids = (omitted_standard_ids - [standard.id]).uniq
    save!
  end

  def included_standards
    ids = guidelines.map { |g| g.standard_applications.map(&:standard_id) }.flatten.uniq
    ids = (ids + included_standard_ids).uniq
    ids = (ids - omitted_standard_ids)
    if ids.empty?
      []
    else
      Standard.where(:id => ids)
    end
  end

  def included_skills_standard_ids
    read_attribute(:included_skills_standard_ids) || []
  end
  
  def omitted_skills_standard_ids
    read_attribute(:omitted_skills_standard_ids) || []
  end

  def omit_skills_standard!(standard)
    self.included_skills_standard_ids = (included_skills_standard_ids - [standard.id]).uniq
    self.omitted_skills_standard_ids = (omitted_skills_standard_ids + [standard.id]).uniq
    save!
  end

  def include_skills_standard!(standard)
    self.included_skills_standard_ids = (included_skills_standard_ids + [standard.id]).uniq
    self.omitted_skills_standard_ids = (omitted_skills_standard_ids - [standard.id]).uniq
    save!
  end

  def included_skills_standards
    ids = skills_guidelines.map { |g| g.standard_applications.map(&:standard_id) }.flatten.uniq
    ids = (ids + included_skills_standard_ids).uniq
    ids = (ids - omitted_skills_standard_ids)
    if ids.empty?
      []
    else
      Standard.where(:id => ids)
    end
  end

  def toggle_cross_curricular_link!(connection)
    if omitted_cross_curricular_links.include?(connection.id)
      update_attribute :omitted_cross_curricular_links, (omitted_cross_curricular_links - [connection.id]).uniq
    else
      update_attribute :omitted_cross_curricular_links, (omitted_cross_curricular_links << connection.id).uniq
    end
  end

  def omitted_cross_curricular_links
    read_attribute(:omitted_cross_curricular_links) || []
  end

  def omitted_cross_knowledge
    KnowledgeConnection.where(:id => omitted_cross_curricular_links).map(&:cross_knowledge).compact.uniq
  end

  def knowledge_connections
    @knowledge_connections ||= KnowledgeConnection.where(:guideline_id => guideline_ids)
  end

  def prior_knowledge_connections
    knowledge_connections.map(&:prior_knowledge).compact.uniq
  end

  def future_knowledge_connections
    knowledge_connections.map(&:future_knowledge).compact.uniq
  end

  def cross_curriculum_connections
    knowledge_connections.map(&:cross_knowledge).compact.uniq
  end

  def vocabulary
    read_attribute(:vocabulary) || []
  end

  def add_vocabulary!(word)
    update_attribute :vocabulary, (vocabulary << word).compact.uniq
  end

  def remove_vocabulary!(word)
    update_attribute :vocabulary, (vocabulary - [word]).compact.uniq
  end

end
