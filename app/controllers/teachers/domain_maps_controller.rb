class Teachers::DomainMapsController < ApplicationController

  before_filter :find_school

  def curriculum
    @grade = params[:grade] || @school.grades.first
    @subjects = CurriculumNode.roots.order('position asc').all
    assign_school_year
    @scheduled_domains = @school_year.scheduled_domains.where(:grade => params[:grade])
  end

  def domain_map
    assign_school_year
    load_domain_map
    @domain_units = DomainUnitDecorator.decorate(current_user.school.domain_units.for_domain_map(@domain_map))
  end

  private

  def load_domain_map
    @domain = Domain.find(params[:domain_id])
    @domain_map = @school.domain_maps.where(:domain_id => @domain.id, :school_year_id => @school_year.id).first_or_create!
  end

  def load_standards
    @standards_json ||= Rails.cache.fetch("ccss_standards_json", :expires_in => 1.day) do
      Standard.common.select([ :id, :ck_code, :text ]).all.to_json(:methods => [ :short_text ])
    end
  end

  def assign_school_year
    @school_year ||= if params[:school_year_id]
                       current_user.update_attribute :last_school_year_id, params[:school_year_id]
                       @school.school_years.find(params[:school_year_id])
                     elsif current_user.last_school_year_id
                       @school.school_years.find(current_user.last_school_year_id) rescue @school.school_year
                     else
                       @school.school_year
                     end
  end


end
