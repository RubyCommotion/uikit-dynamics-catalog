class SpecHelper

  def self.create_help_methods
    SpecHelper.alloc.init
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

  def window_cleanup(window, controller)
    window = nil
    controller = nil
  end

  def calc_distance_and_angle(view)
    attachment_view_controller = AttachmentsView.alloc.init
    attachment_view_controller.view.trackAndDrawAttachmentFromView(attachment_view_controller.attachment_view,
                                                                    toView: attachment_view_controller.square1,
                                                                    withAttachmentOffset: CGPointMake(-25.0, -25.0))
    attachment_point_view_center =  attachment_view_controller.view.send(:create_attachment_points)
    calc_distance_and_angle = attachment_view_controller.view.send(:calc_distance_and_angle,
                                                                      attachment_point_view_center[:attachment_point_view_center],
                                                                      attachment_point_view_center[:attached_view_attachment_point])
  end


  def create_object_with_method_x
    AttachmentPointFail.alloc.init
  end


end
