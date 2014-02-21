class GravityViewController < BaseViewController
  def viewDidLoad
    super
    self.box = new_box(100, 100)
    self.view.addSubview(box)
  end

  def viewDidAppear(animated)
    super
    gravity_behavior = UIGravityBehavior.alloc.initWithItems([box])
    animator.addBehavior(gravity_behavior)
  end
end
