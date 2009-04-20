class Item < ActiveRecord::Base
  has_many :transactions
  belongs_to :shop
  has_one :picture, :dependent => :destroy 
  
  validates_uniqueness_of :barcode, :on => :create, :message => "doppelt vorhanden!"
  validates_size_of :barcode, :minimum => 8, :on => :create, :message => "Kein gültiger EAN8 oder EAN13 Code"
  validates_presence_of :price, :on => :create, :message => "Es ist kein Artikelpreis angegeben"
  validates_presence_of :stock, :on => :create, :message => "Lagerstand muss gesetzt werden"
  validates_presence_of :shop, :on => :create, :message => "Shop muss gesetzt werden"
   
  def self.find_lower_joules(joules)
    find(:all, :conditions => ["joule <= ?", joules], :order => "joule DESC", :limit => 5 )
  end 
    
end
