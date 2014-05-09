class PendulumBehaviour < UIDynamicBehavior
  attr_accessor :draggingBehavior, :pushBehavior

  def initWithWeight(item, suspendedFromPoint:p)
    init

    self.pushBehavior = UIPushBehavior.alloc.initWithItems([item], mode:UIPushBehaviorModeInstantaneous)
    pushBehavior.active = false

    self.addChildBehavior( UIGravityBehavior.alloc.initWithItems([item]))
    self.addChildBehavior( UIAttachmentBehavior.alloc.initWithItem(item, attachedToAnchor:p))
    self.addChildBehavior(pushBehavior)
    self.draggingBehavior = UIAttachmentBehavior.alloc.initWithItem(item, attachedToAnchor:CGPointZero)
    self
  end

  def begin_dragging_weight_at_point(p)
    self.draggingBehavior.anchorPoint = p
    self.addChildBehavior(draggingBehavior)
  end

  def drag_weight_to_point(p)
    self.draggingBehavior.anchorPoint = p
  end

  def end_dragging_weight_with_velocity(v)
    v = CGPointMake(-7.0, 11.0)
    magnitude = Math.sqrt(((v.x)**2.0)+((v.y)**2.0))
    magnitude /= 500
    angle = Math.atan2(v.y, v.x)

    self.pushBehavior.angle = angle
    self.pushBehavior.magnitude = magnitude
    self.pushBehavior.active = true

    self.removeChildBehavior(self.draggingBehavior)
  end
end
