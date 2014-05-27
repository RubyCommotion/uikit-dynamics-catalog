class SpecHelper

  def self.create_help_methods
    SpecHelper.alloc.init
  end

  def calc_distance_and_angle(view)
    attachment_view_controller = AttachmentsView.alloc.init(DecorationView.alloc.init)
    attachment_view_controller.view.trackAndDrawAttachmentFromView(attachment_view_controller.attachment_view,
                                                                    toView: attachment_view_controller.square1,
                                                                    withAttachmentOffset: CGPointMake(-25.0, -25.0))
    attachment_point_view_center =  attachment_view_controller.view.send(:create_attachment_points)
    calc_distance_and_angle = attachment_view_controller.view.send(:calc_distance_and_angle,
                                                                      attachment_point_view_center[:attachment_point_view_center],
                                                                      attachment_point_view_center[:attached_view_attachment_point])
  end

  def do_methods_respond(controller, *method_list)
    method_list.each do |method|
      unless controller.send(:respond_to? ,method)
        return "Method: #{method.to_s} did not respond"
      end
    end
    'All Methods responded'
  end

  def test_image_view(image_name, img_vw_attr, origin_x, y_origin)

    # does ImageView's image exist?
    image = UIImage.imageNamed(image_name)
    if image.nil?
      return "ImageView\'s Image was not found."
    end

    if img_vw_attr.class != UIImageView
      return "attr_accessor's class is #{img_vw_attr.class} where it should be an instance of UIImageView."
    end

    if img_vw_attr.frame.origin.x != origin_x || img_vw_attr.frame.origin.y != y_origin
    return "UIImageView origin coordinates do not match parameter x of #{origin_x} and/or param y of #{y_origin}."
    end

    if img_vw_attr.frame.size.width != image.size.width || img_vw_attr.frame.size.height != image.size.height
      return 'ImageView\'s frame size width and height do not match image size width and height.'
    end
  true
  end

  def create_object_with_method_x
    AttachmentPointFail.alloc.init
  end


  def view_controller_instances_exist(controllers)
    controller_test_results = true
    controllers.each do  |controller|
        controller_instance = controller[:controller].alloc.init
        unless controller_instance == UIViewController || UITableViewController
          controller_test_results = false
        end
      end
  controller_test_results
  end
end
