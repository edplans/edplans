class AddOmittedDomainsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :omitted_domains, :text

  end
end
