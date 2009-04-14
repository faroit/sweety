class ItemsController < ApplicationController
 
  def index
    @items = Item.paginate :page => params[:page], :per_page => 10
    
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end
  
  def stock
  end

  def edit
    @item = Item.find(params[:id])
  end



  def create
    @item = Item.new(params[:item])
    @picture = Picture.new(:uploaded_data => params[:picture_file])
    @service = ItemService.new(@item, @picture) 
    
   respond_to do |format|
       if @service.save
       
          if @item.barcode.blank?
             # Generierung eines gültigen EAN 8 Barcodes
             # Zunächst wird eine 7 stellige Nummer aus dem privaten Bereich erzeugt
             # Schema lautet 2 + user.id (aufgefüllt mit Nullen auf 3 Stellen) + 3 Nullen
             # In den letzten drei Nullen könnte auch eine Artikelnummer stehen
       
             barcode = "2" + @item.id.to_s.rjust(11,'0')       
             # Berechnung der Prüfziffer z aus dem Barcode

              numbers = barcode.to_s.gsub(/[\D]+/, "").split(//)
                  checksum = 0
                  0.upto(numbers.length-1) do |i| checksum += numbers[i].to_i * (i%2*3 +(i-1)%2) end
              z = ((10 - checksum % 10)%10).to_s

               barcode << z.to_s # Prüfziffer an den Barcode anhängen
              @item.update_attribute(:barcode, barcode)        
	          end
       
       flash[:notice] = 'Der Artikel wurde erfolgreich angelegt'
       format.html { redirect_to(:action => 'index') }
       format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @item = Item.find(params[:id])
    @picture = @item.picture 
    @service = ItemService.new(@item, @picture) 

    respond_to do |format|
      if @service.update_attributes(params[:item], params[:picture_file])
        flash[:notice] = 'Der Artikel wurde erfolgreich bearbeitet'
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        @picture = @item.picture 
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end

  def who
    tr = Transaction.find_last_from(params[:item])
    unless tr.nil?
       render :update do |page|
          page.alert "#{tr.user.name} am #{tr.updated_at.to_s(:short)}"
        end
    else
      render :update do |page|
          page.alert "Keine Transaktionen gebucht!"
      end
    end
  end
end