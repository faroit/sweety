class Picture < ActiveRecord::Base 
  belongs_to :item
    has_attachment  :content_type => :image, 
                    :storage => :file_system, 
                    :max_size => 500.kilobytes, 
                    :resize_to => '300x300>', 
                    :thumbnails => { :medium => '64x64!', :small => '32x32!' }, 
                    :processor => :MiniMagick
      
      validate :attachment_valid? 
      
      def attachment_valid? 
      content_type = attachment_options[:content_type] 
      unless content_type.nil? || content_type.include?(self.content_type) 
        errors.add_to_base("Es muss sich um eine Bilddatei handeln!") 
      end 
      
      size = attachment_options[:size] 
      unless size.nil? || size.include?(self.size) 
        errors.add_to_base("Bild darf nicht grösser als 500 Kb sein") 
      end 
    end 
end 
