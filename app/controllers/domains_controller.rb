class DomainsController < ApplicationController

  before_filter :require_admin_or_planner, :except => [ :new, :create ]
  before_filter :require_admin, :only => [ :new, :create ]

  def new
    @domain = Domain.new
  end

  def create
    @domain = Domain.new(params[:domain])
    if @domain.save
      redirect_to domain_path(@domain, :grade => @domain.grade)
    else
      flash[:error] = "There was a problem creating this domain."
      render :new
    end
  end

  def show
    @domain = Domain.find(params[:id])
    unless @grade = CurriculumNode.at_depth(1).where(:name => School.grade_name_for(params[:grade])).first
      flash[:notice] = "No curriculum available here."
    end
    @curriculum_nodes = DomainApplication.where(:applicable_type => 'CurriculumNode', :applicable_id => @grade.try(:subtree_ids), :domain_id => @domain.id).includes(:applicable).all.map(&:applicable)
  end

  def grades
    @grades = School::GRADES
  end

  def grade
    @domains = Domain.common.for_grade(params[:grade])
  end

end
