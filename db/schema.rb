# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140328185655) do

  create_table "curriculum_nodes", :force => true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.integer  "position"
    t.text     "notes"
    t.text     "prior_knowledge"
    t.text     "resources"
    t.text     "future_knowledge"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "ancestry_depth",   :default => 0
  end

  add_index "curriculum_nodes", ["ancestry"], :name => "index_curriculum_nodes_on_ancestry"
  add_index "curriculum_nodes", ["name"], :name => "index_curriculum_nodes_on_name"

  create_table "domain_applications", :force => true do |t|
    t.integer  "applicable_id"
    t.string   "applicable_type"
    t.integer  "domain_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "domain_applications", ["applicable_type", "applicable_id"], :name => "index_domain_applications_on_applicable_type_and_applicable_id"
  add_index "domain_applications", ["domain_id"], :name => "index_domain_applications_on_domain_id"

  create_table "domain_maps", :force => true do |t|
    t.integer  "school_id"
    t.integer  "domain_id"
    t.text     "guideline_ids"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "skills_guideline_ids"
    t.text     "vocabulary"
    t.text     "included_standards"
    t.text     "included_skills_standards"
    t.text     "included_standard_ids"
    t.text     "included_skills_standard_ids"
    t.text     "omitted_cross_curricular_links"
    t.text     "omitted_standard_ids"
    t.text     "omitted_skills_standard_ids"
    t.integer  "school_year_id"
  end

  add_index "domain_maps", ["domain_id", "school_year_id"], :name => "index_domain_maps_on_domain_id_and_school_year_id"
  add_index "domain_maps", ["school_id", "domain_id"], :name => "index_domain_maps_on_school_id_and_domain_id"

  create_table "domain_units", :force => true do |t|
    t.integer  "domain_map_id"
    t.integer  "teacher_id"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "subject_id"
    t.integer  "school_id"
  end

  add_index "domain_units", ["domain_map_id", "teacher_id"], :name => "index_domain_units_on_domain_map_id_and_teacher_id"
  add_index "domain_units", ["domain_map_id"], :name => "index_domain_units_on_domain_map_id"
  add_index "domain_units", ["school_id"], :name => "index_domain_units_on_school_id"
  add_index "domain_units", ["teacher_id"], :name => "index_domain_units_on_teacher_id"

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "grade"
    t.integer  "days"
    t.integer  "position"
    t.string   "tag"
    t.integer  "school_id"
  end

  add_index "domains", ["name"], :name => "index_domains_on_name"
  add_index "domains", ["school_id"], :name => "index_domains_on_school_id"

  create_table "guidelines", :force => true do |t|
    t.text     "name",               :limit => 255
    t.integer  "curriculum_node_id"
    t.text     "notes"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "school_id"
  end

  add_index "guidelines", ["curriculum_node_id"], :name => "index_guidelines_on_curriculum_node_id"
  add_index "guidelines", ["name"], :name => "index_guidelines_on_name"
  add_index "guidelines", ["school_id"], :name => "index_guidelines_on_school_id"

  create_table "knowledge_connections", :force => true do |t|
    t.integer  "guideline_id"
    t.integer  "prior_knowledge_id"
    t.integer  "future_knowledge_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "cross_knowledge_id"
    t.string   "prior_knowledge_type"
    t.string   "cross_knowledge_type"
    t.string   "future_knowledge_type"
  end

  add_index "knowledge_connections", ["guideline_id", "cross_knowledge_id"], :name => "cross_curricular_connections"
  add_index "knowledge_connections", ["guideline_id", "future_knowledge_id"], :name => "future_knowledge_connections"
  add_index "knowledge_connections", ["guideline_id", "prior_knowledge_id"], :name => "prior_knowledge_connections"
  add_index "knowledge_connections", ["guideline_id"], :name => "index_knowledge_connections_on_guideline_id"

  create_table "lesson_plan_files", :force => true do |t|
    t.integer  "lesson_plan_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "lesson_plan_files", ["lesson_plan_id"], :name => "index_lesson_plan_files_on_lesson_plan_id"

  create_table "lesson_plans", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.text     "read_aloud_resources"
    t.text     "materials_and_resources"
    t.text     "procedures"
    t.text     "extensions"
    t.text     "support_and_enrichment"
    t.text     "ongoing_assessment"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.text     "description"
    t.text     "previously_learned_content"
    t.text     "content_objectives"
    t.text     "language_art_objectives"
    t.text     "vocabulary_tier_2_words"
    t.integer  "domain_unit_id"
    t.boolean  "shared",                     :default => true
    t.integer  "teacher_id"
    t.text     "team_notes"
    t.text     "personal_notes"
    t.text     "measurable_objectives"
    t.text     "public_notes"
    t.text     "checked_sub_guidelines"
    t.integer  "copied_from_id"
    t.text     "guidelines_included"
    t.text     "criteria_for_success"
    t.text     "essential_understanding"
  end

  add_index "lesson_plans", ["copied_from_id"], :name => "index_lesson_plans_on_copied_from_id"
  add_index "lesson_plans", ["domain_unit_id"], :name => "index_lesson_plans_on_domain_unit_id"
  add_index "lesson_plans", ["school_id", "shared"], :name => "index_lesson_plans_on_school_id_and_shared"
  add_index "lesson_plans", ["school_id"], :name => "index_lesson_plans_on_school_id"
  add_index "lesson_plans", ["school_id"], :name => "index_lesson_plans_on_school_id_and_domain_map_id"
  add_index "lesson_plans", ["teacher_id"], :name => "index_lesson_plans_on_teacher_id"

  create_table "login_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scheduled_domains", :force => true do |t|
    t.integer  "school_id"
    t.integer  "domain_id"
    t.integer  "start_week"
    t.string   "grade"
    t.integer  "days"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "subject_id"
    t.integer  "school_year_id"
  end

  add_index "scheduled_domains", ["school_id", "domain_id"], :name => "index_scheduled_domains_on_school_id_and_domain_id"
  add_index "scheduled_domains", ["school_id"], :name => "index_scheduled_domains_on_school_id"
  add_index "scheduled_domains", ["school_year_id"], :name => "index_scheduled_domains_on_school_year_id"

  create_table "scheduled_lesson_plans", :force => true do |t|
    t.date     "date"
    t.integer  "school_year_id"
    t.integer  "teacher_id"
    t.integer  "lesson_plan_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "scheduled_lesson_plans", ["school_year_id", "teacher_id"], :name => "index_scheduled_lesson_plans_on_school_year_id_and_teacher_id"

  create_table "school_holidays", :force => true do |t|
    t.integer  "school_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "school_holidays", ["school_id"], :name => "index_school_holidays_on_school_id"

  create_table "school_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "school_memberships", ["school_id"], :name => "index_school_memberships_on_school_id"
  add_index "school_memberships", ["user_id"], :name => "index_school_memberships_on_user_id", :unique => true

  create_table "school_years", :force => true do |t|
    t.integer  "school_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.text     "schedule",   :default => "[\"A\"]"
  end

  add_index "school_years", ["school_id"], :name => "index_school_years_on_school_id"

  create_table "schools", :force => true do |t|
    t.integer  "planner_id"
    t.string   "name"
    t.date     "year_start"
    t.date     "year_end"
    t.text     "holidays"
    t.string   "grades"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "omitted_domains"
  end

  add_index "schools", ["planner_id"], :name => "index_schools_on_planner_id"

  create_table "standard_applications", :force => true do |t|
    t.integer  "standard_id"
    t.integer  "guideline_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "standard_applications", ["guideline_id"], :name => "index_standard_applications_on_guideline_id"
  add_index "standard_applications", ["standard_id"], :name => "index_standard_applications_on_standard_id"

  create_table "standards", :force => true do |t|
    t.string   "subject"
    t.integer  "position"
    t.string   "ck_code"
    t.string   "ck_align"
    t.string   "strand_code"
    t.string   "strand"
    t.string   "category"
    t.text     "text"
    t.string   "origin"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "grade"
    t.integer  "school_id"
  end

  add_index "standards", ["category"], :name => "index_standards_on_category"
  add_index "standards", ["ck_code"], :name => "index_standards_on_ck_code"
  add_index "standards", ["grade", "strand", "position"], :name => "index_standards_on_grade_and_strand_and_position"
  add_index "standards", ["grade", "strand"], :name => "index_standards_on_grade_and_strand"
  add_index "standards", ["grade", "subject"], :name => "index_standards_on_grade_and_subject"
  add_index "standards", ["grade"], :name => "index_standards_on_grade"
  add_index "standards", ["school_id"], :name => "index_standards_on_school_id"
  add_index "standards", ["strand"], :name => "index_standards_on_strand"
  add_index "standards", ["subject"], :name => "index_standards_on_subject"

  create_table "sub_guidelines", :force => true do |t|
    t.integer  "guideline_id"
    t.text     "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "sub_guidelines", ["guideline_id"], :name => "index_sub_guidelines_on_guideline_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                              :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.boolean  "admin",                           :default => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "invitation_token"
    t.boolean  "planner",                         :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "teacher",                         :default => false
    t.boolean  "active",                          :default => true
    t.integer  "last_school_year_id"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
