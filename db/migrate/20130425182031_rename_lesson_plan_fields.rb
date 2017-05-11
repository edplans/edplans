class RenameLessonPlanFields < ActiveRecord::Migration
  def change
    rename_column :lesson_plans, :procedure, :procedures
    rename_column :lesson_plans, :extension_activity, :extensions
    rename_column :lesson_plans, :scaffolding_and_support, :support_and_enrichment
    rename_column :lesson_plans, :materials, :materials_and_resources
  end
end
