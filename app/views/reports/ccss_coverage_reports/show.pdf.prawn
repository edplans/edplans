prawn_document do |pdf|
  pdf.text @report.school.name, :size => 16
  pdf.text @report.school_year.short_form, :size => 16
  pdf.text @report.subject_name, :size => 16 if @report.subject.present?
  if @report.grade.present?
    pdf.text "Standards Planning Report for #{ School.grade_name_for(@report.grade )}", :size => 16
  else
    pdf.text "Standards Planning Report", :size => 16
  end

  table = []
  table << ["Standards", "Planned?", "Domain/Topic", "Grade Level", "Start Week"]
  @report.grades.each do |grade|
    table << [School.grade_name_for(grade), "", "", "", ""] unless @report.grade
    @report.strands_for_grade(grade).each do |strand|
      @report.categories_for_grade_and_strand(grade, strand).each do |category|
        category_header = pdf.make_cell :content => "#{ strand }: #{ category }", :size => 16
        table << [category_header, "", "", "", ""]
        @report.standards_for_grade_strand_and_category(grade, strand, category).each do |standard|
          domain_maps = @report.domain_maps_with_standard_taught(standard, grade).reverse
          if !domain_maps.empty? && @report.include_planned?
            first_map = domain_maps.pop
            table << [pdf.make_cell("#{standard.ck_code} #{standard.text} #{standard.strand}", :inline_format => true), first_map.nil? ? "X" : "Y", render(:partial => 'reports/domain', :locals => { :domain => first_map.domain, :pdf => pdf }), grade, first_map.scheduled_domain.start_week]
            domain_maps.reverse.each do |map|
              table << ["", "", render(:partial => 'reports/domain', :locals => { :domain => map.domain, :pdf => pdf }), grade, map.scheduled_domain.start_week]
            end
          elsif domain_maps.empty? && @report.include_unplanned?
            table << [pdf.make_cell("#{standard.ck_code} #{standard.text} #{standard.strand}", :inline_format => true), "X", nil, grade, nil]
          end
        end
      end
    end
  end

  pdf.table table, :column_widths => {1 => 80}, :header => true

  render :partial => 'reports/key', :locals => { :pdf => pdf }

  render :partial => 'reports/footer', :locals => { :pdf => pdf }
end
