class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.decimal :user_id
      t.string :name
      t.string :shopicon_file_name
      t.string :shopicon_content_type
      t.integer :shopicon_file_size
      t.datetime :shopicon_updated_at    
      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
