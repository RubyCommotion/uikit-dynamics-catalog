class GravitySpringController < BaseViewController
  attr_accessor :attachment, :square

  def loadView
    self.view = DecorationView.alloc.init
  end

  def viewDidLoad
    super
    view.addSubview create_instructions_label
    view.addSubview square
    view.addSubview attachment_view
    gravity = UIGravityBehavior.alloc.initWithItems([square])
    collision = UICollisionBehavior.alloc.initWithItems([square])
    collision.translatesReferenceBoundsIntoBoundary = true
    anchor_point = CGPointMake(square.center.x, square.center.y)
    attachment_point = UIOffsetMake(-25.0, -25.0)
    self.attachment = UIAttachmentBehavior.alloc.initWithItem(square, offsetFromCenter: attachment_point, attachedToAnchor: anchor_point)
    attachment.setFrequency 1.0
    attachment.setDamping 0.1
    animator.addBehavior attachment
    animator.addBehavior collision
    animator.addBehavior gravity

    create_gesture_recognizer

    attachment_view.center = attachment.anchorPoint
    view.trackAndDrawAttachmentFromView(attachment_view, toView: square, withAttachmentOffset: CGPointZero)
  end

  def handle_attachment_gesture(gesture)
    attachment.setAnchorPoint(gesture.locationInView(view))
    attachment_view.center = attachment.anchorPoint
  end

  def create_gesture_recognizer
    pan_gesture_recognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "handle_attachment_gesture:")
    view.addGestureRecognizer(pan_gesture_recognizer)
  end

  def square
    @square ||= UIView.alloc.initWithFrame([[110, 135], [100, 100]]).tap do |sq|
      sq.userInteractionEnabled = false
      sq.addSubview new_box(0,0)
      attachment_point_mask_image = UIImage.imageNamed("attachment_point_mask")
      square_attachment_view = UIImageView.alloc.initWithFrame([[44, 44], [attachment_point_mask_image.size.height, attachment_point_mask_image.size.width]])
      square_attachment_view.image = attachment_point_mask_image
      square_attachment_view.center = CGPointMake(25.0, 25.0)
      square_attachment_view.tintColor = UIColor.blueColor
      square_attachment_view.image = square_attachment_view.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)

      sq.addSubview(square_attachment_view)
    end
  end

  def attachment_view
    @attachment_view ||=  UIImageView.alloc.initWithFrame([[12, 76], [attachment_point_mask_image.size.height, attachment_point_mask_image.size.width]]).tap do |att_vw|
      att_vw.image = attachment_point_mask_image
      att_vw.tintColor = UIColor.redColor
      att_vw.image = att_vw.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
    end
  end

  def attachment_point_mask_image
    @attachment_point_mask_image ||= UIImage.imageNamed("attachment_point_mask")
  end

  def create_instructions_label
    @label ||= UILabel.alloc.initWithFrame([[20, 504], [280, 44]]).tap do |lbl|
      lbl.enabled = false
      lbl.contentMode = UIViewContentModeLeft
      lbl.clipsToBounds = true
      lbl.text = 'Drag red circle to move the square.'
      lbl.adjustsFontSizeToFitWidth = true
      #lbl.textColor = UIColor.darkTextColor
      lbl.font = UIFont.fontWithName('Chalkduster', size:15)
    end
  end

end
