DomainPlanner::Application.routes.draw do

  get '/sign_in' => 'user_sessions#new', :as => :sign_in
  post '/sign_in' => 'user_sessions#create', :as => :sign_in
  get '/sign_out' => 'user_sessions#destroy', :as => :sign_out

  get '/welcome-back' => 'welcome#welcome_back', :as => :user_landing

  scope 'about' do
    get 'core_knowledge' => 'about#core_knowledge', :as => :about_core_knowledge
    get 'terms_of_use' => 'about#terms_of_use', :as => :about_terms_of_use
    get 'software' => 'about#software', :as => :about_software
  end

  resources :password_resets, :except => [ :index, :destroy, :show ]

  get '/invitations/:role/new' => 'invitations#new', :as => :new_invitation
  post '/invitations/:role' => 'invitations#create', :as => :invitations
  get '/invitations/accept/:token' => 'invitations#show', :as => :accept_invitation
  put '/invitations/accept/:token' => 'invitations#accept', :as => :accept_invitation

  get '/school_invitations/new' => 'invitations#new_school', :as => :new_school_invitation
  post '/school_invitations' => 'invitations#create_school', :as => :school_invitations

  resources :users, :only => [ :index, :destroy ] do
    member do
      put :activate
      put :deactivate
      put :resend_invitation
    end
  end
  get 'users/all.csv' => 'users#csv'

  get '/me', :to => 'users#edit'
  put '/me', :to => 'users#update'

  get '/my_school/edit' => 'my_school#edit', :as => :edit_my_school
  put '/my_school' => 'my_school#update', :as => :my_school

  scope 'my_school' do
    resources :scheduled_domains
    resources :school_holidays
    resources :school_years, :controller => 'my_school/school_years'

    get 'school_years/:id/transfer' => 'my_school/school_years#transfer', :as => :transfer_school_year
    put 'school_years/:id/transfer' => 'my_school/school_years#complete_transfer'

    get 'school_years/:id/schedule' => 'my_school/school_years#schedule', :as => :school_year_schedule
    put 'school_years/:id/schedule' => 'my_school/school_years#update_schedule'

    resources :domains, :controller => 'my_school/domains', :as => :custom_domains, :only => [:create, :destroy, :update]
    resources :standards, :controller => 'my_school/standards', :as => :custom_standards, :only => [ :create, :destroy, :update ]
    resources :guidelines, :controller => 'my_school/guidelines', :as => :custom_guidelines, :only => [ :create, :destroy, :update ]

    scope '/users' do
      get '/', :to => 'my_school/users#index', :as => :my_school_users
      put '/:id/activate', :to => 'my_school/users#activate', :as => :activate_user
      put '/:id/deactivate', :to => 'my_school/users#deactivate', :as => :deactivate_user
      put '/:id/promote', :to => 'my_school/users#promote', :as => :promote_user
      put '/:id/demote', :to => 'my_school/users#demote', :as => :demote_user
    end

    scope '/domain_maps/:domain_id/school_years/:school_year_id' do
      get '/', :to => 'my_school/domain_maps#show', :as => :domain_map
      post '/guidelines/:guideline_id', :to => 'my_school/mapped_guidelines#create', :as => :mapped_guidelines
      delete '/guidelines/:guideline_id', :to => 'my_school/mapped_guidelines#destroy', :as => :mapped_guidelines
      post '/skills_guidelines/:guideline_id', :to => 'my_school/mapped_skills_guidelines#create', :as => :mapped_skills_guidelines
      delete '/skills_guidelines/:guideline_id', :to => 'my_school/mapped_skills_guidelines#destroy', :as => :mapped_skills_guidelines

      put '/included_standards/:id', :to => 'my_school/domain_maps#include_standard', :as => 'include_standard'
      delete '/included_standards/:id', :to => 'my_school/domain_maps#omit_standard', :as => 'omit_standard'
      get '/included_standards', :to => 'my_school/domain_maps#included_standards', :as => 'included_standards'
      put '/included_skills_standards/:id', :to => 'my_school/domain_maps#include_skills_standard', :as => 'include_skills_standard'
      delete '/included_skills_standards/:id', :to => 'my_school/domain_maps#omit_skills_standard', :as => 'omit_skills_standard'
      get '/included_skills_standards', :to => 'my_school/domain_maps#included_skills_standards', :as => 'included_skills_standards'

      put '/toggle_cross_curricular_link/:id', :to => 'my_school/domain_maps#toggle_cross_curricular_link', :as => 'toggle_cross_curricular_link'

      put '/vocabulary', :to => 'my_school/domain_maps#add_vocabulary', :as => 'domain_map_vocabulary'
      delete '/vocabulary/:word', :to => 'my_school/domain_maps#remove_vocabulary', :as => 'domain_map_vocabulary_word'
    end

    get '/teachers/invitations/new', :to => 'my_school/teacher_invitations#new', :as => :new_teacher_invitation
    post '/teachers/invitations', :to => 'my_school/teacher_invitations#create', :as => :teacher_invitations

    get '/planners/invitations/new', :to => 'my_school/planner_invitations#new', :as => :new_my_school_planner_invitation
    post '/planners/invitations', :to => 'my_school/planner_invitations#create', :as => :my_school_planner_invitations


  end

  get '/domains' => 'domains#grades', :as => :domains
  get '/domains/new' => 'domains#new', :as => :new_domain
  post '/domains' => 'domains#create', :as => :domains
  get '/domains/:grade' => 'domains#grade', :as => :domains_grade
  get '/domains/:grade/:id' => 'domains#show', :as => :domain

  scope '/admin' do

    scope '/curriculum' do
      get '/' => 'curriculum#index', :as => :curriculum
      get '/upload' => 'curriculum#new', :as => :upload_curriculum
      post '/' => 'curriculum#upload', :as => :curriculum
      delete '/' => 'curriculum#clear', :as => :clear_curriculum
      get '/curriculum/node/:id' => 'curriculum#node', :as => :curriculum_node

      get 'node/:id/children/new' => 'admin/curriculum_nodes#new', :as => :new_child_curriculum_node
      get 'node/new' => 'admin/curriculum_nodes#new', :as => :new_curriculum_node
      post 'nodes' => 'admin/curriculum_nodes#create', :as => :curriculum_nodes
      get 'node/:curriculum_node_id/guidelines/new' => 'admin/guidelines#new', :as => :new_guideline
      post 'node/:curriculum_node_id/guidelines' => 'admin/guidelines#create', :as => :guidelines

      get '/curriculum/node/:id/edit' => 'curriculum#edit', :as => :edit_curriculum_node
      put '/curriculum/node/:id' => 'curriculum#update', :as => :curriculum_node
      delete '/curriculum/node/:id' => 'curriculum#destroy', :as => :curriculum_node
    end

    scope '/domains' do
      get '/' => 'admin/domains#new', :as => :upload_domains
      post '/' => 'admin/domains#upload', :as => :upload_domains
      delete '/' => 'admin/domains#clear', :as => :clear_domains
      put '/:id' => 'admin/domains#update', :as => :admin_domain
      delete '/:id' => 'admin/domains#destroy', :as => :admin_domain
    end

    resources :guidelines, :only => [ :show, :edit, :update, :destroy], :controller => 'admin/guidelines' do
      resources :knowledge_connections, :only => [ :create, :destroy ], :controller => 'admin/knowledge_connections'
      resources :domain_applications, :only => [ :create, :destroy ], :controller => 'admin/guideline_domain_applications'
      resources :standard_applications, :only => [ :create, :destroy ], :controller => 'admin/guideline_standard_applications'
      resources :sub_guidelines, :only => [ :create ], :controller => 'admin/sub_guidelines'
    end
    resources :sub_guidelines, :only => [ :edit, :update, :destroy ], :controller => 'admin/sub_guidelines'

    resources :standards, :controller => 'admin/standards'

    get '/upload/standards' => 'admin/standards#new_upload', :as => :new_standards_upload
    get '/standards/*ck_code' => 'admin/standards#show', :as => :standard
    post '/upload/standards' => 'admin/standards#upload', :as => :upload_standards
    delete '/standards' => 'admin/standards#clear', :as => :clear_standards

    get 'logins' => 'admin/login_events#index', :as => :login_events
    get 'schools' => 'admin/schools#index', :as => :admin_schools
    get 'lesson_plans' => 'admin/lesson_plans#index', :as => :admin_lesson_plans
  end

  get 'schools' => 'schools#index', :as => :schools

  get '/curriculum/plan/:grade' => 'my_school#plan', :as => :plan_curriculum
  get '/curriculum/plan/:grade/domains' => 'my_school#domains'
  get '/curriculum/plan/:grade/scheduled_domains' => 'my_school#scheduled_domains'

  get '/my_school/curriculum/(:grade)' => 'teachers/domain_maps#curriculum', :as => :show_curriculum
  get '/my_school/curriculum/school_years/:school_year_id/domain_map/:domain_id' => 'teachers/domain_maps#domain_map', :as => :show_domain_map

  get '/my_calendar' => 'teachers/calendar#show', :as => :teacher_calendar
  get '/my_calendar/events' => 'teachers/calendar#events', :as => :teacher_calendar_events
  post '/my_calendar/:school_year_id/:month_fragment' => 'teachers/calendar#persist_month'

  post '/school_years/:school_year_id/scheduled_lesson_plans' => 'teachers/scheduled_lesson_plans#create', :as => :scheduled_lesson_plans

  get '/guidelines/:guideline_id/knowledge_connections' => 'knowledge_connections#index', :as => :knowledge_connections

  scope '/domains/:domain_id' do
    resources :domain_units, :only => [ :create, :update, :destroy ], :controller => 'schools/domain_units' do
      resources :lesson_plans, :controller => 'teachers/lesson_plans' do
        member { put :clone; put :public_notes }
      end
    end
  end

  resources :lesson_plans, :only => [ :show ], :controller => 'teachers/lesson_plans'

  scope '/reports' do

    # Reports

    get '/', :to => 'reports#index', :as => :reports

    [ :grade_domain_report, :subject_domain_report, :ccss_coverage_report, :domain_week_report, :ss_coverage_report, :full_domain_report, :domain_lessons_report, :related_knowledge_report ].each do |report|
      get "#{ report }/new", :to => "reports/#{ report.to_s.pluralize }#new", :as => "new_#{ report }"
      get "#{ report }", :to => "reports/#{ report.to_s.pluralize }#show", :as => "#{ report }"
    end

  end

  scope '/lesson_plans/:lesson_plan_id/' do
    resources :lesson_plan_files, :only => [ :create, :destroy ], :controller => 'teachers/lesson_plan_files'
    put 'subguidelines/:id/check', :to => 'teachers/lesson_plans#check_sub_guideline', :as => :check_sub_guideline
    delete 'subguidelines/:id/check', :to => 'teachers/lesson_plans#uncheck_sub_guideline', :as => :uncheck_sub_guideline
  end

  scope '/curriculum' do

    get '/' => 'public_curriculum/curriculum_nodes#index', :as => :public_curriculum
    get '/:id' => 'public_curriculum/curriculum_nodes#show', :as => :public_curriculum_node
    get '/guidelines/:id' => 'public_curriculum/guidelines#show', :as => :public_guideline

  end

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

  get '/copyright' => 'welcome#copyright', :as => :copyright
  root :to => 'welcome#index'

end
