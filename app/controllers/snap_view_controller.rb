class SnapViewController < BaseViewController
  attr_accessor :snap_behavior

  def viewDidLoad
    super
    self.box = new_box(100, 100)
    self.view.addSubview(box)
    gesture = UITapGestureRecognizer.alloc.initWithTarget(self, action: "handle_tap:")
    self.view.addGestureRecognizer(gesture)
  end

  def handle_tap(gesture)
    point = gesture.locationInView(view)
    animator.removeBehavior(self.snap_behavior)
    self.snap_behavior = UISnapBehavior.alloc.initWithItem(box, snapToPoint: point)
    animator.addBehavior(self.snap_behavior)
  end
end
