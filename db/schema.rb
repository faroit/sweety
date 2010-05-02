# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100502121846) do

  create_table "items", :force => true do |t|
    t.string   "barcode"
    t.integer  "shop_id",            :limit => 10, :precision => 10, :scale => 0
    t.string   "name"
    t.text     "description"
    t.decimal  "price",                            :precision => 8,  :scale => 2
    t.decimal  "cost",                             :precision => 8,  :scale => 2
    t.integer  "joule",              :limit => 10, :precision => 10, :scale => 0
    t.integer  "stock",              :limit => 10, :precision => 10, :scale => 0
    t.integer  "discount_thres",     :limit => 10, :precision => 10, :scale => 0
    t.decimal  "discount",                         :precision => 3,  :scale => 2
    t.integer  "sell_limit",         :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "photo_remote_url"
  end

  create_table "shops", :force => true do |t|
    t.integer  "user_id",    :limit => 10, :precision => 10, :scale => 0
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "user_id",    :limit => 10, :precision => 10, :scale => 0
    t.integer  "item_id",    :limit => 10, :precision => 10, :scale => 0
    t.decimal  "amount",                   :precision => 8,  :scale => 2
    t.integer  "quantity"
    t.boolean  "pm"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "barcode"
    t.string   "name"
    t.string   "nick"
    t.string   "mail"
    t.decimal  "amount",                     :precision => 8,  :scale => 2
    t.decimal  "budget",                     :precision => 8,  :scale => 2
    t.integer  "joule_budget", :limit => 10, :precision => 10, :scale => 0
    t.string   "icon_url"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
