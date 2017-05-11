class MySchool::DomainMapsController < ApplicationController

  before_filter :require_planner, :find_school, :load_domain_map, :load_standards

  def show
    @subjects = CurriculumNode.roots.order('position asc').all
    @curriculum_nodes = @subjects.inject({}) { |acc, s| acc[s] = s.subtree_for_grade(@domain.grade_name); acc }
  end

  def toggle_cross_curricular_link
    @link = KnowledgeConnection.find(params[:id])
    @domain_map.toggle_cross_curricular_link!(@link)
    respond_to do |format|
      format.json { render :json => @link }
    end
  end

  def omit_standard
    @standard = Standard.find(params[:id])
    @domain_map.omit_standard!(@standard)
    respond_to do |format|
      format.json { render :json => @standard }
    end
  end

  def include_standard
    @standard = Standard.find(params[:id])
    @domain_map.include_standard!(@standard)
    respond_to do |format|
      format.json { render :json => @standard }
    end
  end

  def included_standards
    @standards = @domain_map.included_standards
    respond_to do |format|
      format.json { render :json => StandardDecorator.decorate(@standards) }
    end
  end

  def omit_skills_standard
    @standard = Standard.find(params[:id])
    @domain_map.omit_skills_standard!(@standard)
    respond_to do |format|
      format.json { render :json => @standard }
    end
  end

  def include_skills_standard
    @standard = Standard.find(params[:id])
    @domain_map.include_skills_standard!(@standard)
    respond_to do |format|
      format.json { render :json => @standard }
    end
  end

  def included_skills_standards
    @standards = @domain_map.included_skills_standards
    respond_to do |format|
      format.json { render :json => StandardDecorator.decorate(@standards) }
    end
  end

  def add_vocabulary
    @domain_map.add_vocabulary!(params[:word])
    respond_to do |format|
      format.json { render :json => @domain_map.vocabulary }
    end
  end

  def remove_vocabulary
    @domain_map.remove_vocabulary!(params[:word])
    respond_to do |format|
      format.json { render :json => @domain_map.vocabulary }
    end
  end

  private

  def school_year
    @school_year ||= if params[:school_year_id]
                       current_user.update_attribute :last_school_year_id, params[:school_year_id]
                       @school.school_years.find(params[:school_year_id])
                     elsif current_user.last_school_year_id
                       @school.school_years.find(current_user.last_school_year_id) rescue @school.school_year
                     else
                       @school.school_year
                     end
  end

  def load_domain_map
    @domain = Domain.find(params[:domain_id])
    @domain_map = @school.domain_maps.where(:domain_id => @domain.id, :school_year_id => school_year.id).first_or_create!
  end

  def load_standards
    @standards_json ||= Rails.cache.fetch("ccss_standards_json", :expires_in => 1.day) do
      StandardDecorator.all.to_json
    end
    @included_standards ||= StandardDecorator.decorate(@domain_map.included_standards)
    @included_skills_standards ||= StandardDecorator.decorate(@domain_map.included_skills_standards)
  end

end
