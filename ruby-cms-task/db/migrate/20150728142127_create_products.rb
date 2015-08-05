 class CreateProducts < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.column 'name', :string, :limit => 30
      t.column 'sku', :integer  
      t.column 'category', :string, :limit => 30
      # t.datetime 'created_at'
      # t.datetime 'updated_at'   both in timestamp
      t.timestamps null: false
    end
  end

  def down
  	drop_table :products	
  end
end
 