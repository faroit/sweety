class Shop < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_attached_file :shopicon, :styles => { :medium => "300x300>", :thumb => "50x50" }, :default_url => "/images/default_shop_:style.png"
end
