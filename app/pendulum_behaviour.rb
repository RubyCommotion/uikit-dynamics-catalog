class PendulumBehaviour < UIDynamicBehavior
  attr_accessor :draggingBehavior, :pushBehavior

  def initWithWeight(item, suspendedFromPoint:p)
    init
    #self = [super init];
    # The high-level pendulum behavior is built from 2 primitive behaviors.

    gravityBehavior = UIGravityBehavior.alloc.initWithItems([item])
    attachmentBehavior = UIAttachmentBehavior.alloc.initWithItem(item, attachedToAnchor:p)

    # These primative behaviors allow the user to drag the pendulum weight.
    draggingBehavior = UIAttachmentBehavior.alloc.initWithItem(item, attachedToAnchor:CGPointZero)
    pushBehavior = UIPushBehavior.alloc.initWithItems([item], mode:UIPushBehaviorModeInstantaneous)

    pushBehavior.active = false

    self.addChildBehavior(gravityBehavior)
    self.addChildBehavior(attachmentBehavior)

    self.addChildBehavior(pushBehavior)
    # The draggingBehavior is added as needed, when the user begins dragging the weight.

    self.draggingBehavior = draggingBehavior
    self.pushBehavior = pushBehavior
    return self
  end

  def beginDraggingWeightAtPoint(p)
    self.draggingBehavior.anchorPoint = p
    self.addChildBehavior(self.draggingBehavior)
  end


  def dragWeightToPoint(p)
    self.draggingBehavior.anchorPoint = p
  end


  def endDraggingWeightWithVelocity(v)
    magnitude = Math.sqrt(((v.x)**2.0)+((v.y)**2.0))
    angle = Math.atan2(v.y, v.x)

    # Reduce the volocity to something meaningful.  (Prevents the user from flinging the pendulum weight).
    magnitude /= 500

    self.pushBehavior.angle = angle
    self.pushBehavior.magnitude = magnitude
    self.pushBehavior.active = true

    self.removeChildBehavior(self.draggingBehavior)
  end

end

