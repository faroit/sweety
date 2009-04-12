class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def list_barcodes
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def barcode
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
       
       # Generierung eines gültigen EAN 8 Barcodes
       # Zunächst wird eine 7 stellige Nummer aus dem privaten Bereich erzeugt
       # Schema lautet 2 + user.id (aufgefüllt mit Nullen auf 3 Stellen) + 3 Nullen
       # In den letzten drei Nullen könnte auch eine Artikelnummer stehen
       
       barcode = "2" + @user.id.to_s.rjust(3,'0').ljust(6,'0')
       
       # Berechnung der Prüfziffer aus dem Barcode
       
       weight=[3,1]*6 # Hashtable aus den Multiplikatoren 3 und 1
            magic=10  
            sum = 0
            for i in 0..6         # Durchgehen der ersten 7 Ziffern
               sum = sum + barcode[i].to_i * weight[i]
            end
            z = ( magic - (sum % magic) ) % magic # Berechnung des modulos
            if z < 0 or z >= magic
               return None
            end
        
        barcode << z.to_s # Prüfziffer an den Barcode anhängen
        
        @user.update_attribute(:barcode, barcode)        
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def check_bmr
    weight = params[:guide_weight].to_i
    size = params[:guide_size].to_i
    age = params[:guide_age].to_i
    result = (4.1868) * (66.5 + (13.8 * weight) + (5.0 * size) - (6.8 * age))
     render :update do |page|
        page[:user_joule_budget].value =  result
        page.visual_effect :highlight, :user_joule_budget
      end
  end
  
  def invoice
    @users = User.find(:all, :conditions => ['amount <= -1.0', ])
    for user in @users
      Postoffice.deliver_invoice(user)
    end
    flash[:notice] = "Mahnungen wurden versandt!"
    # render the default action
    redirect_to :action => "index"
  end
  
  def stockwarning
    for shop in Shop.find(:all)
      trs = Transaction.find_low_stock(shop)
      unless trs.empty?
         Postoffice.deliver_stockwarning(shop, shop.user, trs) 
      end
    end
    
    flash[:notice] = "Bestandsmeldungen wurden versandt!"
    # render the default action
    redirect_to :action => "index"
  end
  

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    unless Shop.exists?(:user_id => @user.id)
      Transaction.delete_all(:user_id => @user.id)
      @user.destroy
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    else
       flash[:notice] = 'User kann nicht gelöscht werden, da noch als Shopmanager eingetragen'
      redirect_to :controller => "shops", :action => "managed_by", :user_id => @user.id
    end
    
  end
end
