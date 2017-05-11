class AddFieldNamesToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :description, :text
    add_column :lesson_plans, :previously_learned_content, :text
    add_column :lesson_plans, :content_objectives, :text
    add_column :lesson_plans, :language_art_objectives, :text
    add_column :lesson_plans, :cross_curricular_connections, :text
    add_column :lesson_plans, :sayings_and_phrases, :text
    add_column :lesson_plans, :vocabulary_tier_2_words, :text
    add_column :lesson_plans, :vocabulary_tier_3_words, :text
    add_column :lesson_plans, :summative_evaluation, :text
    add_column :lesson_plans, :bibliography, :text
    rename_column :lesson_plans, :assessment_methods, :ongoing_assessment
  end
end
