class Postoffice < ActionMailer::Base
  
  def invoice(user)
      @recipients   = user.mail
      @from         = "'Gatrobe Shop-System' <shop@gatrobe.faroit.com>"
      headers         "Reply-to" => "shop@gatrobe.faroit.com"
      @subject      = "Dein Kontostand beträgt: #{user.amount}"
      @sent_on      = Time.now
      @content_type = "text/html"
      body  :user => user
  end
  
  def stockwarning(shop, user, tr)
      @recipients   = user.mail
      @from         = "'Gatrobe Shop-System' <shop@gatrobe.faroit.com>"
      headers         "Reply-to" => "shop@gatrobe.faroit.com"
      @subject      = "Aktueller Lagerbestand #{shop.name}"
      @sent_on      = Time.now
      @content_type = "text/html"
      body  :shop => shop, :tr => tr 
  end
  
end
