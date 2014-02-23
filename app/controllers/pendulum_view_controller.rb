class PendulumViewController < BaseViewController
  attr_accessor :attachmentPoint, :pendulumBehavior, :animator

  def loadView
    self.view = DecorationView.alloc.init
  end

  def viewDidLoad
    super

    self.box = new_box(100, 300)
    self.view.addSubview(box)

    image = UIImage.imageNamed("attachment_point")

    self.attachmentPoint = UIImageView.alloc.initWithFrame([[150, 120], [image.size.height, image.size.width]])
    self.attachmentPoint.image = image
    self.view.addSubview(self.attachmentPoint)

    self.attachmentPoint.tintColor = UIColor.redColor
    self.attachmentPoint.image = self.attachmentPoint.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)

    # Visually show the connection between the attachmentPoint and the box. 

    self.view.trackAndDrawAttachmentFromView(self.attachmentPoint,toView:self.box,withAttachmentOffset:CGPointMake(0, -0.95 * self.box.bounds.size.height/2))

    animator = UIDynamicAnimator.alloc.initWithReferenceView(self.view)

    pendulumAttachmentPoint = self.attachmentPoint.center

    # An example of a high-level behavior simulating a simple pendulum.
    pendulumBehavior = PendulumBehaviour.alloc.initWithWeight(self.box,suspendedFromPoint:pendulumAttachmentPoint)
    animator.addBehavior(pendulumBehavior)
    self.pendulumBehavior = pendulumBehavior

    self.animator = animator
  end

  def dragWeight(gesture)
    #TODO: replace this with a case
    if (gesture.state == UIGestureRecognizerStateBegan) 
      self.pendulumBehavior.beginDraggingWeightAtPoint(gesture.locationInView(self.view))
    elsif (gesture.state == UIGestureRecognizerStateEnded)
      self.pendulumBehavior.endDraggingWeightWithVelocity(gesture.velocityInView(self.view))
    elsif (gesture.state == UIGestureRecognizerStateCancelled)
      gesture.enabled = YES
      self.pendulumBehavior.endDraggingWeightWithVelocity(gesture.velocityInView(self.view))
    elsif (!CGRectContainsPoint(self.box.bounds, gesture.locationInView(self.box)))
      gesture.enabled = NO
    else
      self.pendulumBehavior.dragWeightToPoint(gesture.locationInView(self.view))
    end
  end
end
