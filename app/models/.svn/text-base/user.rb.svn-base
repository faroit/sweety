class User < ActiveRecord::Base
  has_many :transactions
  has_many :shops
  validates_presence_of :amount, :on => :create, :message => "Kontostand muss gesetzt werden"
  validates_presence_of :joule_budget, :on => :update, :on => :create, :message => "Bitte setzen"
  
  def highscore
    
  end
  
  def joules_left(user)
    left = user.joule_budget - Transaction.joules_today(user)
  end
  
end
