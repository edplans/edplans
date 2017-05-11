class MakeGuidelineNameText < ActiveRecord::Migration
  def up
    change_column :guidelines, :name, :text
  end

  def down
    change_column :guidelines, :name, :string
  end
end
