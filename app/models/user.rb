class User < ActiveRecord::Base
  has_many :transactions
  has_many :shops
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
  
  def joules_left(user)
    left = user.joule_budget - Transaction.joules_today(user)
  end
end
