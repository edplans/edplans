class RemoveContentFromGuidelines < ActiveRecord::Migration
  def up
    remove_column :guidelines, :content
  end

  def down
    add_column :guidelines, :content, :text
  end
end
