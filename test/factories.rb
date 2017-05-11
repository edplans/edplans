FactoryGirl.define do

  factory :user do |u|
    u.email { Faker::Internet.email }
    u.password "password123"
    u.admin false
    u.planner false
  end

  factory :admin, :parent => :user do |a|
    a.admin true
  end

  factory :planner, :parent => :user do |p|
    p.planner true
    p.association :school
  end

  factory :teacher, :parent => :user do |t|
    t.teacher true
    t.association :school
  end

  factory :curriculum_node do |c|
    c.name { Faker::Lorem.words(3).join(' ') }
    c.notes { Faker::Lorem.paragraph }
  end

  factory :guideline do |g|
    g.name { Faker::Lorem.words(3).join(' ') }
    g.association :curriculum_node
  end

  factory :sub_guideline do |s|
    s.association :guideline
    s.name { Faker::Lorem.words(3).join(' ') }
  end

  factory :domain do |d|
    d.name { Faker::Lorem.words(2).join(' ').titleize }
    d.grade { %w(K 1 2 3 4 5 6 7 8).sample }
    d.days { (1..24).to_a.sample }
    d.tag "Interdisciplinary"
  end

  factory :school do |s|
    s.name { "#{ Faker::Lorem.name } Elementary" }
    s.grades %w(K 1 2 3 4 5 6 7 8)
  end

  factory :school_year do |y|
    y.association :school
    y.start_date { Date.today + 1.month }
    y.end_date { Date.today + 13.months }
  end

  factory :scheduled_domain do |s|
    s.association :school
    s.association :domain
    s.association :subject, :factory => :curriculum_node
    s.start_week { (1..10).to_a.sample }
    s.grade { School::GRADES.sample }
    s.days { (1..15).to_a.sample }
  end

  factory :school_holiday do |h|
    h.association :school
    h.start_date { Date.today + 3.months }
    h.name { "#{ Faker::Lorem.word.titleize } Day" }
  end

  factory :domain_map do |m|
    m.association :school
    m.association :domain
  end

  factory :standard do |s|
    s.subject { (0..2).map{ generate :random_cap }.join }
    s.ck_code { "#{ generate :random_cap }.#{ generate :random_cap }.#{ generate :int }" }
    s.ck_align { "#{ generate :random_cap }#{ generate :random_cap }.#{ generate :int }" }
    s.strand_code { "#{ generate :random_cap }#{ generate :random_cap }.#{ generate :int }" }
    s.strand { Faker::Lorem.words(2).join(' ').titleize }
    s.category { Faker::Lorem.words(4).join(' ').titleize }
    s.text { Faker::Lorem.sentence }
    s.origin "CCSS"
    s.grade { School::GRADES.sample }
  end
  
  sequence :random_cap do
    65.+(rand(25)).chr
  end

  sequence :int do |n|
    n
  end

  factory :standard_application do |s|
    s.association :standard
    s.association :guideline
  end

  factory :lesson_plan do |l|
    l.association :domain_unit
    l.association :teacher
    l.ongoing_assessment { Faker::Lorem.paragraph }
    l.name { Faker::Lorem.words(2).join(' ').titleize }
  end

  factory :domain_unit do |d|
    d.association :domain_map
    d.association :teacher
    d.name { Faker::Lorem.word.titleize }
  end
end

    
