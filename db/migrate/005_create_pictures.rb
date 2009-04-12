class CreatePictures < ActiveRecord::Migration 
  def self.up 
    create_table :pictures do |t| 
      t.integer :item_id, :parent_id, :size, :width, :height 
      t.string :content_type, :filename, :thumbnail 
      t.timestamps 
    end 
  end 

  def self.down 
    drop_table :pictures 
  end 
end 

