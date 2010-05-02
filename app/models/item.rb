require 'open-uri'

class Item < ActiveRecord::Base
  attr_accessor :photo_url
  
  has_many :transactions
  belongs_to :shop
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "50x50" }, :default_url => "/images/default_item_:style.png", :convert_options => { :thumb => '-background white -gravity center -extent 50x50' }
  
  before_validation :download_remote_photo, :if => :photo_url_provided?
  validates_presence_of :photo_remote_url, :if => :photo_url_provided?, :message => 'is invalid or inaccessible'
  validates_uniqueness_of :barcode, :on => :create, :message => "doppelt vorhanden!"
  validates_size_of :barcode, :minimum => 8, :on => :update, :message => "Kein gültiger EAN8 oder EAN13 Code"
  validates_presence_of :price, :on => :create, :message => "Es ist kein Artikelpreis angegeben"
  validates_presence_of :stock, :on => :create, :message => "Lagerstand muss gesetzt werden"
  validates_presence_of :shop, :on => :create, :message => "Shop muss gesetzt werden"
   
  def self.find_lower_joules(joules)
    find(:all, :conditions => ["joule <= ?", joules], :order => "joule DESC", :limit => 5 )
  end 
    
private

      def photo_url_provided?
        !self.photo_url.blank?
      end

      def download_remote_photo
        self.photo = do_download_remote_photo
        self.photo_remote_url = photo_url
      end

      def do_download_remote_photo
        io = open(URI.parse(photo_url))
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
      end
    
    
end
