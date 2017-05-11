class StandardDecorator < ApplicationDecorator

  decorates :standard

  def as_json(opts = {})
    { :id => id, :ck_code => ck_code, :text => text, :short_text => short_text }
  end

end
