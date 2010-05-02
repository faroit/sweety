class AddImageRemoteUrlToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :photo_remote_url, :string
  end
 
  def self.down
    remove_column :items, :photo_remote_url
  end
end