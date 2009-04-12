class ItemService 
  attr_reader :item, :picture 

  def initialize(item, picture) 
    @item = item 
    @picture = picture 
  end 

  def save 
    return false unless valid?    
      begin 
      Item.transaction do 
        if @picture.new_record? 
          @item.picture.destroy if @item.picture 
          @picture.item = @item 
          @picture.save!
        end 
        @item.save! 
        true 
      end 
    rescue 
      false 
    end 
  end 
  
  def update_attributes(item_attributes, picture_file) 
    @item.attributes = item_attributes 
  unless picture_file.blank? 
    @picture = Picture.new(:uploaded_data => picture_file) 
  end 
    save 
  end 
  
  def valid? 
    @item.valid? && @picture.valid? 
  end 
end 
