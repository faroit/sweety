class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :barcode
      t.decimal :shop_id
      t.string :name
      t.text :description
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :cost, :precision => 8, :scale => 2
      t.decimal :joule
      t.decimal :stock
      t.decimal :discount_thres
      t.decimal :discount, :precision => 3, :scale => 2
      t.decimal :sell_limit

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
