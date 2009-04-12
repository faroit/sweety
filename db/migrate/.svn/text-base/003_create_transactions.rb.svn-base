class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.decimal :user_id
      t.decimal :item_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :quantity
      t.boolean :pm
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
