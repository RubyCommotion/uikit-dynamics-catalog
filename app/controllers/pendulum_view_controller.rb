class PendulumViewController < BaseViewController

  def loadView
    self.view = DecorationView.alloc.init
  end

  def viewDidLoad
    super
    view.addSubview(create_instructions_label)
    create_box_image_view_subview
    create_attachment_point_image_view_subview

    # Visually show the connection between the attachment_point and the box.
    self.view.trackAndDrawAttachmentFromView(self.attachment_point, toView:self.box,withAttachmentOffset:CGPointMake(0, -0.95 * self.box.bounds.size.height/2))

    # An example of a high-level behavior simulating a simple pendulum.
    self.pendulum_behavior = PendulumBehaviour.alloc.initWithWeight(self.box,suspendedFromPoint:self.attachment_point.center)
    animator.addBehavior(pendulum_behavior)

    gesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "drag_weight:")
    self.view.addGestureRecognizer(gesture)
  end

  protected
  attr_accessor :attachment_point, :pendulum_behavior

  private

  def create_box_image_view_subview
    self.box = new_box(100, 270)
    self.view.addSubview(box)
  end

  def create_attachment_point_image_view_subview
    image = UIImage.imageNamed("attachment_point")
    self.attachment_point = UIImageView.alloc.initWithFrame([[150, 120], [image.size.height, image.size.width]])
    attachment_point.image = image
    self.view.addSubview(attachment_point)
    attachment_point.tintColor = UIColor.redColor
    attachment_point.image = attachment_point.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
    attachment_point
  end

  def drag_weight(gesture)

    dragged_within_box_bounds = CGRectContainsPoint(self.box.bounds, gesture.locationInView(self.box))
    unless dragged_within_box_bounds
      return
    end

    case gesture.state
    when UIGestureRecognizerStateBegan
      self.pendulum_behavior.begin_dragging_weight_at_point(gesture.locationInView(self.view))
    when UIGestureRecognizerStateEnded
      self.pendulum_behavior.end_dragging_weight_with_velocity(gesture.velocityInView(self.view))
    when UIGestureRecognizerStateCancelled
      gesture.enabled = true
      self.pendulum_behavior.end_dragging_weight_with_velocity(gesture.velocityInView(self.view))
    else
      self.pendulum_behavior.drag_weight_to_point(gesture.locationInView(self.view))
    end
  end

  def create_instructions_label
    @label ||= UILabel.alloc.initWithFrame([[20, 504], [280, 44]]).tap do |lbl|
      lbl.enabled = false
      lbl.contentMode = UIViewContentModeLeft
      lbl.clipsToBounds = true
      lbl.text = 'Drag box to swing pendulum.'
      lbl.adjustsFontSizeToFitWidth = true
      lbl.font = UIFont.fontWithName('Chalkduster', size:15)
    end
  end
end
