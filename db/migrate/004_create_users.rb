class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :barcode
      t.string :name
      t.string :nick
      t.string :mail
      t.decimal :amount, :precision => 8, :scale => 2
      t.decimal :budget, :precision => 8, :scale => 2
      t.decimal :joule_budget
      t.string :icon_url
      t.datetime :last_login
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
