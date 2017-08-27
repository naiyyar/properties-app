module Paperclip
  class Rotator < Thumbnail
    def transformation_command
      if rotate_command
        super + rotate_command
      else
        super
      end
    end
    
    def rotate_command
      target = @attachment.instance
      if target.rotating?
        [convert_options = "-rotate #{target.rotation}"]
      end
    end
  end
end

# module Paperclip
#   class Rotator < Thumbnail
#     # def initialize(file, options = {}, attachment = nil)
#     #   options[:auto_orient] = false
#     #   super
#     # end

#     def transformation_command
#       if rotate_command
#         rotate_command + super.join(' ')
#       else
#         super
#       end
#     end

#     def rotate_command
#       target = @attachment.instance
#       if target.rotate.present?
#         #{}" -rotate #{target.rotate}"
#         [convert_options = ["-rotate", "#{target.rotate}"]]
#       end
#     end
#   end
# end