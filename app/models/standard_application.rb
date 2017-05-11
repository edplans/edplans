class StandardApplication < ActiveRecord::Base

  belongs_to :standard
  belongs_to :guideline

  validates_uniqueness_of :standard_id, :scope => :guideline_id

  attr_accessible :standard_id

  def standard_text
    standard.text
  end

  def standard_ck_code
    standard.ck_code
  end

  def standard_short_text
    standard.short_text
  end

end
