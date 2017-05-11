class LessonPlanFile < ActiveRecord::Base

  belongs_to :lesson_plan

  attr_accessible :attachment

  has_attached_file :attachment, :storage => :s3,
  :bucket => "#{ ENV['S3_BUCKET_NAME'] || 'domain_planner' }#{ '-' + Rails.env unless Rails.env.production? }",
  :s3_credentials => { :access_key_id => ENV['S3_ACCESS_KEY_ID'],
                       :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'] }
  

end
