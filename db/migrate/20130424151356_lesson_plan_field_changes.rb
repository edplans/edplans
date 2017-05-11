class LessonPlanFieldChanges < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :criteria_for_success, :text
#    remove_column :lesson_plans, :previously_learned_contest
    remove_column :lesson_plans, :prerequisite_skills
    remove_column :lesson_plans, :cross_curricular_connections
    remove_column :lesson_plans, :sayings_and_phrases
    remove_column :lesson_plans, :vocabulary_tier_3_words
    remove_column :lesson_plans, :comprehension_questions
    remove_column :lesson_plans, :summative_evaluation
    remove_column :lesson_plans, :bibliography
#    remove_column :lesson_plans, :text
  end
end
