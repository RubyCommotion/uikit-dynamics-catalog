class AttachmentsView < BaseViewController

  def loadView
    self.view = DecorationView.alloc.init
  end


  def viewDidLoad
    super
    self.box = new_box(100, 100)
    self.view.addSubview(box)

    # Creates collision boundaries from the bounds of the dynamic animator's
    # reference view (self.view).

    collision_behavior.translatesReferenceBoundsIntoBoundary = true
    animator.addBehavior(collision_behavior)

    box_center_point = CGPointMake(self.box.center.x, self.box.center.y - 110.0)

    attachment_point = UIOffsetMake(-25.0, -25.0)

    # By default, an attachment behavior uses the center of a view. By using a
    # small offset, we get a more interesting effect which will cause the view
    # to have rotation movement when dragging the attachment.

    attachment_behavior = UIAttachmentBehavior.alloc.initWithItem(self.box, offsetFromCenter: attachment_point, attachedToAnchor: box_center_point)
    animator.addBehavior(attachment_behavior)
    self.attachment_behavior = attachment_behavior

    # Visually show the attachment points
    self.attachment_view.center = attachment_behavior.anchorPoint
    self.attachment_view.tintColor = UIColor.redColor
    self.attachment_view.image = self.attachment_view.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)

    self.box_attachment_view.center = CGPointMake(25.0, 25.0)
    self.box_attachment_view.tintColor = UIColor.blueColor
    self.box_attachment_view.image = self.box_attachment_view.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)

    # Visually show the connection between the attachment points.
    self.view.trackAndDrawAttachmentFromView(self.attachment_view, toView: self.box, withAttachmentOffset: CGPointMake(-25.0, -25.0))
    # TODO verify following statement not needed
    #self.animator = animator
    end


  #  IBAction for the Pan Gesture Recognizer that has been configured to track
  #  touches in self.view.
  #
  def handleAttachmentGesture(gesture)
      self.attachment_behavior.setAnchorPoint(gesture.locationInView(self.view))
      self.attachment_view.center = self.attachment_behavior.anchorPoint
  end

end