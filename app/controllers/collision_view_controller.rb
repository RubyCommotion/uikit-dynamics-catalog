class CollisionViewController < BaseViewController
  def viewDidLoad
    super
    self.box = new_box(100, 100)
    self.view.addSubview(box)
  end

  def viewDidAppear(animated)
    super
    gravity_behavior = UIGravityBehavior.alloc.initWithItems([box])
    animator.addBehavior(gravity_behavior)

    collision_behavior = UICollisionBehavior.alloc.initWithItems([box])
    collision_behavior.collisionDelegate = self
    collision_behavior.translatesReferenceBoundsIntoBoundary = true
    animator.addBehavior(collision_behavior)
  end
end