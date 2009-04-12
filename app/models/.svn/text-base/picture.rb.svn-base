class Picture < ActiveRecord::Base 
  belongs_to :item
    has_attachment  :content_type => :image, 
                    :storage => :file_system, 
                    :max_size => 500.kilobytes, 
                    :resize_to => '300x300>', 
                    :thumbnails => { :medium => '64x64!', :small => '32x32!' }, 
                    :processor => :MiniMagick
                    
    validates_as_attachment 
end 
