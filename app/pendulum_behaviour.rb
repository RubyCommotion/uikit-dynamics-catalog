class PendulumBehaviour < UIDynamicBehavior
  attr_accessor :draggingBehavior, :pushBehavior

  def initWithWeight(item, suspendedFromPoint:p)
    init

    gravityBehavior    = UIGravityBehavior.alloc.initWithItems([item])
    attachmentBehavior = UIAttachmentBehavior.alloc.initWithItem(item, attachedToAnchor:p)
    draggingBehavior   = UIAttachmentBehavior.alloc.initWithItem(item, attachedToAnchor:CGPointZero)
    pushBehavior       = UIPushBehavior.alloc.initWithItems([item], mode:UIPushBehaviorModeInstantaneous)

    pushBehavior.active = false

    self.addChildBehavior(gravityBehavior)
    self.addChildBehavior(attachmentBehavior)

    self.addChildBehavior(pushBehavior)

    self.draggingBehavior = draggingBehavior
    self.pushBehavior = pushBehavior
    self
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

    magnitude /= 500

    self.pushBehavior.angle = angle
    self.pushBehavior.magnitude = magnitude
    self.pushBehavior.active = true

    self.removeChildBehavior(self.draggingBehavior)
  end
end
