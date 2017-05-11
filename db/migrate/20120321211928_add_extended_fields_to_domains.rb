class AddExtendedFieldsToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :grade, :string

    add_column :domains, :days, :integer

    add_column :domains, :position, :integer

    add_column :domains, :tag, :string

  end
end
