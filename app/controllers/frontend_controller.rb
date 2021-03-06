class FrontendController < ApplicationController
	
	def index
	  # rendering index.html.erb template
	end
	
	def login
	  @user = User.find(params[:id])
	  respond_to do |format|
      format.html { render :action => "login" }
    end
  end
  
	def logging_in
    # Business Logic for Login Process running from AJAX request
	  user = User.find(:first, :conditions => [ "barcode = ?", params[:barcode]])
	  if params[:barcode].length < 13
	    user = User.find(:first, :conditions => [ "id = ?", params[:barcode]])
    end
	  if user.nil? && params[:barcode][7,5].to_i.zero?
	    render :update do |page|
        page[:barcode].value = "Barcode ungültig"
        page.visual_effect :pulsate, 'barcode', :duration => 1
        page[:barcode].activate
        page.delay(1) do page[:barcode].value = "" end
      end
	  else
	    
	      @item=Item.find(:first, :conditions => [ "id = ?", params[:barcode][7,5].to_i])
	      usercode = params[:barcode][1,6]
        @user = User.find(:first, :conditions => [ "id = ?", usercode.to_i])
    	  
  	    if @item.nil? && !user.nil?
  	      # login!
           user.update_attributes(:last_login => Time.now)
      	     render :update do |page|
                page.redirect_to :action => 'login', :id => user.id
             end
 
        else
          if !@item.nil?
	        if @user.joules_left(@user) - @item.joule >= 0 || @user.joule_budget.zero? 
             @transaction = Transaction.new(:item_id => @item.id, :amount => @item.price,  :pm => false)
       	    @user.transactions << @transaction
       	    @user.update_attributes(:amount => @user.amount - @transaction.amount)
       	    @item.update_attributes(:stock => @item.stock - 1)
               render :update do |page|
                 page[:barcode].activate
                 page[:barcode].value = "1x #{@item.name}"
                 page.delay(2) do page[:barcode].value = "Vielen Dank!" end
                 page[:barcode].activate
                 page.delay(3) do page[:barcode].value = "" end  
               end
           else
             # Kalorien aufgebraucht
             @fit = Item.find_lower_joules(@user.joules_left(@user))
             render :update do |page|
               page[:barcode].value = "Kalorien aufgebraucht"
               page.visual_effect :pulsate, 'barcode', :duration => 1
               page[:barcode].activate
               page.delay(1) do page[:barcode].value = "" end
             end
          end
        else
           render :update do |page|
             page[:barcode].value = "ungültiger Artikel"
             page.visual_effect :pulsate, 'barcode', :duration => 1
             page[:barcode].activate
             page.delay(1) do page[:barcode].value = "" end
           end
        end
     end
    end
	end
	
	def add_item
    @user=User.find(params[:user])
    case params[:barcode][0,1] # Gibt das 1. Zeichen des barcode parameters aus.
        # // ==== STORNO ==== //
        when "-" 
     	    last_transaction = @user.transactions.find(
     	      :first,
     	      :conditions => ["transactions.created_at >= users.last_login AND transactions.pm = false"],
     	      :order => "transactions.created_at DESC", 
     	      :include => [:item, :user])
     	    if last_transaction.nil?
     	      render :update do |page|
               page[:barcode].value = "Storno nicht erlaubt"
               page[:barcode].activate
               page << "resetTimer()"
            end
          else
       		  last_transaction.update_attributes(:pm => true)
       		  last_transaction.item.update_attributes(:stock => last_transaction.item.stock+last_transaction.quantity)
       	    @user.amount += last_transaction.amount*last_transaction.quantity
            @user.save
     	        render :update do |page|
               page[:barcode].value = "Storno"
               page[:barcode].activate
               page.remove "tr_#{last_transaction.id}"
               page.replace_html :amount, number_to_currency(@user.amount, :unit => "&euro;")
               page.replace_html :joules, Transaction.joules_today(@user)
               page << "resetTimer()"
              end
          end
        when "+"  
        multi = params[:barcode].split(//,2)[1].to_i
         # Multiplizieren
          last_transaction = @user.transactions.find(
     	      :first,
     	      :order => "transactions.created_at DESC", 
     	      :include => [:item, :user])
          
          if @user.joules_left(@user) - multi*last_transaction.item.joule >= 0 || @user.joule_budget.zero?
              if (multi+1 >= last_transaction.item.discount_thres && last_transaction.item.discount_thres != 0)
                sum = last_transaction.item.price*(1-last_transaction.item.discount)*(multi+1)
              else
                sum = last_transaction.item.price*multi+ last_transaction.amount
              end
             last_transaction.update_attributes(:amount => sum, :quantity => multi+last_transaction.quantity) 
              @user.update_attributes(:amount => @user.amount - multi*last_transaction.amount)
        	    last_transaction.item.update_attributes(:stock =>  last_transaction.item.stock-multi)
                render :update do |page|
                  page[:barcode].value = ""
                  page[:barcode].activate
                  page.replace "tr_#{last_transaction.id}", :partial => 'transaction', :locals => {:transaction => last_transaction}     
                  page.replace_html :amount, number_to_currency(@user.amount, :unit => "&euro;")
                  page.replace_html :joules, Transaction.joules_today(@user)
                  page.visual_effect :highlight, "tr_#{last_transaction.id}"
                  page << "resetTimer()"
                end
            else
              # Kalorien aufgebraucht
              render :update do |page|
                page[:barcode].value = "Kalorienbudget!"
                page.delay(2) do page.redirect_to :action => :index end
              end
            end
     
      # MANUAL LOGOUT #
     
       when ""
         render :update do |page|
           page.redirect_to :action => :index
         end
       else
         
	       @item=Item.find(:first, :conditions => [ "barcode = ?", params[:barcode]])
	  
	    if @item.nil?
	      render :update do |page|
          page[:barcode].value = "Jibbet nüsch"
          page[:barcode].activate
          page << "resetTimer()"
        end
      else 
        
        # TRANSACTION!
        
        if @user.joules_left(@user) - @item.joule >= 0 || @user.joule_budget.zero? 
       
          @transaction = Transaction.new(:item_id => @item.id, :amount => @item.price, :quantity => 1, :pm => false)
    	    @user.transactions << @transaction
    	    @user.update_attributes(:amount => @user.amount - @transaction.amount)
    	    @item.update_attributes(:stock => @item.stock - 1)
            respond_to do |format|
              format.js
            end
       else
          # Kalorien aufgebraucht
          @fit = Item.find_lower_joules(@user.joules_left(@user))
          render :update do |page|
            page[:barcode].value = "Kalorienbudget!"
            page.replace_html :item, :partial => 'joules'
            page[:barcode].activate
            page << "resetTimer()"
          end
        end
	    end
	  end
  end
end
