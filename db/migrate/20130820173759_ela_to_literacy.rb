class ElaToLiteracy < ActiveRecord::Migration
  def up
    Standard.where(:subject => "ELA").update_all(:subject => "ELA/Literacy")
  end

  def down
    Standard.where(:subject => "ELA/Literacy").update_all(:subject => "ELA")
  end
end
