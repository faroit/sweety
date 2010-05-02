class User < ActiveRecord::Base
  has_many :transactions
  has_many :shops
  has_attached_file :avatar, :styles => { :medium => "250x250>", :thumb => "50x50" }, :default_url => "/images/default_avatar_:style.png"
  
  validates_presence_of :amount, :on => :create, :message => "Kontostand muss gesetzt werden"
  validates_presence_of :joule_budget, :on => :update, :on => :create, :message => "Bitte setzen"
  
  def item_barcode(user,item_id)
    barcode = user.barcode[0,12]
    code = barcode.to_i + item_id
    numbers = code.to_s.gsub(/[\D]+/, "").split(//)
         checksum = 0
         0.upto(numbers.length-1) do |i| checksum += numbers[i].to_i * (i%2*3 +(i-1)%2) end
     z = ((10 - checksum % 10)%10).to_s
    
   code.to_s << z.to_s # Prüfziffer an den Barcode anhängen
  end
  
  def highscore
    
  end
  
  def bought_today(user,item)
        count_by_sql(["
         SELECT SUM(IF(!t.pm, t.quantity, 0)) 
         FROM transactions t 
         JOIN items i ON t.item_id = i.id 
         WHERE t.created_at > ? AND t.user_id = ? AND i.id = ?",
         Time.today, user.id, item.id])
  end
  
  def joules_left(user)
    left = user.joule_budget - Transaction.joules_today(user)
  end
end
