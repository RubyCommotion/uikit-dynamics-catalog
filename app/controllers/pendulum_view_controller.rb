class PendulumViewController < BaseViewController

  def loadView
    self.view = DecorationView.alloc.init
  end

  def viewDidLoad
    super

    create_box_image_view_subview
    create_attachment_point_image_view_subview

    # Visually show the connection between the attachmentPoint and the box. 
    self.view.trackAndDrawAttachmentFromView(self.attachmentPoint,toView:self.box,withAttachmentOffset:CGPointMake(0, -0.95 * self.box.bounds.size.height/2))

    animator = UIDynamicAnimator.alloc.initWithReferenceView(self.view)

    pendulumAttachmentPoint = self.attachmentPoint.center

    # An example of a high-level behavior simulating a simple pendulum.
    pendulumBehavior = PendulumBehaviour.alloc.initWithWeight(self.box,suspendedFromPoint:pendulumAttachmentPoint)
    animator.addBehavior(pendulumBehavior)
    self.pendulumBehavior = pendulumBehavior

    self.animator = animator

    gesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "dragWeight:")
    self.view.addGestureRecognizer(gesture)
  end


  protected
  attr_accessor :attachmentPoint, :pendulumBehavior, :animator

  private

  def create_box_image_view_subview
    self.box = new_box(100, 270)
    self.view.addSubview(box)
    p "Object ids are: #{self.box.object_id} #{self.view.subviews[1].object_id}"
  end

  def create_attachment_point_image_view_subview
    image = UIImage.imageNamed("attachment_point")
    self.attachmentPoint = UIImageView.alloc.initWithFrame([[150, 120], [image.size.height, image.size.width]])
    attachmentPoint.image = image
    self.view.addSubview(attachmentPoint)
    attachmentPoint.tintColor = UIColor.redColor
    attachmentPoint.image = self.attachmentPoint.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
  end

  def dragWeight(gesture)

    case gesture.state
    when UIGestureRecognizerStateBegan
      self.pendulumBehavior.beginDraggingWeightAtPoint(gesture.locationInView(self.view))
    when UIGestureRecognizerStateEnded
      self.pendulumBehavior.endDraggingWeightWithVelocity(gesture.velocityInView(self.view))
    when UIGestureRecognizerStateCancelled
      gesture.enabled = true
      self.pendulumBehavior.endDraggingWeightWithVelocity(gesture.velocityInView(self.view))
    when -> (state)  { (!CGRectContainsPoint(self.box.bounds, gesture.locationInView(self.box))) }
      gesture.enabled = false
    else
      self.pendulumBehavior.dragWeightToPoint(gesture.locationInView(self.view))
    end
  end
end
