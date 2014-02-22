class ItemPropertiesViewController < BaseViewController
  attr_accessor :box_one, :box_two, :box_two_property, :box_one_property

  def viewDidLoad
    super
    self.navigationItem.rightBarButtonItem = new_replay_button
    self.box_one = new_box(40, 100)
    self.view.addSubview(box_one)

    self.box_two = new_box(180, 100)
    self.view.addSubview(box_two)
  end

  def viewDidAppear(animated)
    super
    gravity_behavior = UIGravityBehavior.alloc.initWithItems([box_one, box_two])
    animator.addBehavior(gravity_behavior)

    collision_behavior = UICollisionBehavior.alloc.initWithItems([box_one, box_two])
    collision_behavior.collisionDelegate = self
    collision_behavior.translatesReferenceBoundsIntoBoundary = true
    animator.addBehavior(collision_behavior)

    self.box_two_property = UIDynamicItemBehavior.alloc.initWithItems([box_two])
    self.box_two_property.elasticity = 0.5
    animator.addBehavior(box_two_property)

    self.box_one_property = UIDynamicItemBehavior.alloc.initWithItems([box_one])
    animator.addBehavior(box_one_property)
  end

  def new_replay_button
    UIBarButtonItem.alloc.initWithTitle("Restart", style: UIBarButtonItemStylePlain, target: self, action: "replay_action")
  end

  def replay_action
    self.box_one_property.addLinearVelocity(CGPointMake(0, -1 * box_one_property.linearVelocityForItem(box_one).y), forItem: box_one)
    self.box_one.center = CGPointMake(90, 171)
    animator.updateItemUsingCurrentState(box_one)

    self.box_two_property.addLinearVelocity(CGPointMake(0, -1 * box_two_property.linearVelocityForItem(box_two).y), forItem: box_two)
    self.box_two.center = CGPointMake(230, 171)
    animator.updateItemUsingCurrentState(box_two)
  end
end
