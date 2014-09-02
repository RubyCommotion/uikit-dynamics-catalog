class PendulumViewController < UIViewController
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
    create_instructions_label
    create_box_image_view_subview
    create_attachment_point_image_view_subview

    # Visually show the connection between the attachment_point and the box.
    self.view.trackAndDrawAttachmentFromView(@attachment_point, toView:box,withAttachmentOffset:CGPointMake(0, -0.95 * box.bounds.size.height/2))

    # An example of a high-level behavior simulating a simple pendulum.
    @pb = PendulumBehaviour.alloc.initWithWeight(box,suspendedFromPoint:@attachment_point.center)
    animator.addBehavior(@pb)

    gesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "drag_weight:")
    self.view.addGestureRecognizer(gesture)
  end


  private

  def create_box_image_view_subview
    self.box = new_box(100, 270)
    self.view.addSubview(box)
  end

  def create_attachment_point_image_view_subview
    image = UIImage.imageNamed("attachment_point")
    @attachment_point = UIImageView.alloc.initWithFrame([[150, 120], [image.size.height, image.size.width]])
    @attachment_point.image = image
    self.view.addSubview(@attachment_point)
    @attachment_point.tintColor = UIColor.redColor
    @attachment_point.image = @attachment_point.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
    @attachment_point
  end

  def drag_weight(gesture)

    dragged_within_box_bounds = CGRectContainsPoint(box.bounds, gesture.locationInView(box))
    unless dragged_within_box_bounds
      return
    end

    case gesture.state
    when UIGestureRecognizerStateBegan
      @pb.begin_dragging_weight_at_point(gesture.locationInView(self.view))
    when UIGestureRecognizerStateEnded
      @pb.end_dragging_weight_with_velocity(gesture.velocityInView(self.view))
    when UIGestureRecognizerStateCancelled
      gesture.enabled = true
      @pb.end_dragging_weight_with_velocity(gesture.velocityInView(self.view))
    else
      @pb.drag_weight_to_point(gesture.locationInView(self.view))
    end
  end

  def create_instructions_label
      @label ||= UILabel.alloc.initWithFrame([[20, 439], [280, 21]]).tap do |lbl|
        lbl.enabled = false
        lbl.contentMode = UIViewContentModeLeft
        lbl.clipsToBounds = true
        lbl.text = 'Drag box to swing pendulum.'
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = UIFont.fontWithName('Chalkduster', size:15)
      end
      self.view.addSubview(@label)
    end


end
