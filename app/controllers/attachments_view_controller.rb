class AttachmentsView < UIViewController
  include BaseModule

  def init(decorator_view)
    @decorator_view = decorator_view
    self
  end

  def loadView
    self.view = @decorator_view
  end

  def viewDidLoad
    super
    create_subviews
    create_gesture_recognizer
    create_animator_and_behaviors
    @attachment_view.center = @attachment_behavior.anchorPoint
    self.view.trackAndDrawAttachmentFromView(@attachment_view, toView: @square1, withAttachmentOffset: CGPointMake(-25.0, -25.0))
  end


  private

  def create_subviews
    create_square1_view
    self.view.addSubview(@square1)
    create_instructions_label
    # second attachment point view that is used to drag box1 via its connected attachment point
    create_attachment_view
    self.view.addSubview(@attachment_view)
  end

  def create_gesture_recognizer
    pan_gesture_recognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action: 'handle_attachment_gesture:')
    self.view.addGestureRecognizer(pan_gesture_recognizer)
  end

  def create_animator_and_behaviors
    @collision_behavior = UICollisionBehavior.alloc.initWithItems([@square1])
    @collision_behavior.translatesReferenceBoundsIntoBoundary = true
    animator.addBehavior(@collision_behavior)

    square_center_point = CGPointMake(@square1.center.x, @square1.center.y - 110.0)
    attachment_point = UIOffsetMake(-25.0, -25.0)
    @attachment_behavior = UIAttachmentBehavior.alloc.initWithItem(@square1, offsetFromCenter: attachment_point, attachedToAnchor: square_center_point)
    animator.addBehavior(@attachment_behavior)
  end

  def handle_attachment_gesture(gesture)
    @attachment_behavior.setAnchorPoint(gesture.locationInView(self.view))
    @attachment_view.center = @attachment_behavior.anchorPoint
  end

  def create_square1_view
    @square1 ||= UIView.alloc.initWithFrame([[110, 135], [100, 100]]).tap do |sq1|
      sq1.userInteractionEnabled = false
      box1 = new_box(0,0)
      sq1.addSubview(box1)
      attachment_point_mask_image = UIImage.imageNamed('attachment_point_mask')
      @sq1_attachment_image_view = UIImageView.alloc.initWithFrame([[44, 44], [attachment_point_mask_image.size.height, attachment_point_mask_image.size.width]])
      @sq1_attachment_image_view.image = attachment_point_mask_image
      @sq1_attachment_image_view.center = CGPointMake(25.0, 25.0)
      @sq1_attachment_image_view.tintColor = UIColor.blueColor
      @sq1_attachment_image_view.image = @sq1_attachment_image_view.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
      sq1.addSubview(@sq1_attachment_image_view)
      sq1.setAccessibilityLabel('Square')
      @sq1_attachment_image_view.setAccessibilityLabel('Square Attachment View')
    end
  end

  def create_instructions_label
      @label ||= UILabel.alloc.initWithFrame([[20, 439], [280, 21]]).tap do |lbl|
        lbl.enabled = false
        lbl.contentMode = UIViewContentModeLeft
        lbl.clipsToBounds = true
        lbl.text = 'Drag red circle to move the square.'
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = UIFont.fontWithName('Chalkduster', size:15)
      end
      self.view.addSubview(@label)
    end

  def create_attachment_view
    attachment_point_mask_image = UIImage.imageNamed('attachment_point_mask')
    @attachment_view ||=  UIImageView.alloc.initWithFrame([[12, 76], [attachment_point_mask_image.size.width, attachment_point_mask_image.size.height]]).
                          tap do |att_vw|
      att_vw.image = attachment_point_mask_image
      att_vw.tintColor = UIColor.redColor
      att_vw.image = att_vw.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
      att_vw.setAccessibilityLabel('Attachment View')
    end
  end
end
