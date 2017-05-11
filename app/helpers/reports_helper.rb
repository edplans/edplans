module ReportsHelper

  def class_name_for_domain(domain)
    return "" unless domain.present?
    if domain.is_course_unit?
      'domain-interdisciplinary'
    elsif domain.is_custom?
      'domain-custom'
    end
  end

  class SubjectRow
    attr_accessor :cells, :total_weeks

    def initialize(total_weeks)
      @cells = []
      @total_weeks = total_weeks
    end

    def fill_in_empty_cells
      blank_cell = SubjectRowCell.new(nil, 1)
      @cells.select {|c| c.scheduled_domain.present? }.each do |cell|
        blank_cell.end_week = cell.start_week - 1
        unless blank_cell.end_week < blank_cell.start_week || blank_cell.start_week == cell.start_week
          @cells << blank_cell
        end
        blank_cell = SubjectRowCell.new(nil, cell.end_week + 1)
      end
      blank_cell.end_week = total_weeks
      self.cells << blank_cell unless blank_cell.end_week <= blank_cell.start_week
      @cells.sort! {|a, b| a.start_week <=> b.start_week}
    end

    def overlapping_cell?(cell)
      @cells.any? { |c| c.start_week <= cell.end_week && c.end_week >= cell.start_week }
    end
  end

  class SubjectRowCell
    attr_accessor :scheduled_domain, :start_week, :end_week

    def initialize(scheduled_domain = nil, start_week = nil, end_week = nil)
      @scheduled_domain = scheduled_domain
      @start_week = start_week || scheduled_domain.try(:start_week)
      @end_week = end_week || scheduled_domain.try(:end_week)
    end

    def text
      scheduled_domain.present? ? scheduled_domain.domain_name : ""
    end

    def weeks
      end_week - start_week + 1
    end

    def class_name
      if scheduled_domain.present?
        scheduled_domain.domain_is_course_unit? ?
        "scheduled-domain custom-course-unit" : "scheduled-domain"
      end
    end
  end

  def rows_for_scheduled_domains(scheduled_domains, weeks)
    rows = []
    scheduled_domains.each do |sd|
      cell = SubjectRowCell.new(sd)
      row = rows.find {|r| !r.overlapping_cell?(cell)} || (rows << SubjectRow.new(weeks)).last
      row.cells << cell
    end
    rows.each &:fill_in_empty_cells
    rows
  end
end
