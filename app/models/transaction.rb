class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
    
  def self.find_since_last_week
    find(:all, :conditions => ["created_at > ?", 1.week.ago(Time.now)])
  end
  
  def self.find_last_from(item)
    find(:first, :conditions => ["item_id = ?", item], :order => ["transactions.updated_at DESC"], :include => [:user])
  end
 
  def self.joules_today(user)
     count_by_sql(["
      SELECT SUM(IF(!t.pm, i.joule*t.quantity, 0)) 
      FROM transactions t 
      JOIN items i ON t.item_id = i.id 
      WHERE t.created_at > ? AND t.user_id = ?",
      Date.today, user.id])
  end
  
  def self.find_low_stock(shop)
    find_by_sql(["
      SELECT t.item_id, i.stock stock, i.shop_id 
      FROM transactions t 
      JOIN items i ON t.item_id = i.id 
      WHERE t.created_at > ? AND i.shop_id = ?
      GROUP BY t.item_id 
      HAVING COUNT(t.id)/7 * 3 >= i.stock
      ORDER BY stock DESC", 
      1.week.ago(Time.now), shop.id])
  end
  
 def shop
    self.item.shop.name
  end
end
