class SubGuideline < ActiveRecord::Base

  belongs_to :guideline

  attr_accessible :name

end
