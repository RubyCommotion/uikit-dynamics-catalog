class SnapViewController < UIViewController
  include BaseModule

  def viewDidLoad
    super
    self.view.addSubview(create_instructions_label)
    self.box = new_box(100, 100)
    self.view.addSubview(box)
    gesture = UITapGestureRecognizer.alloc.initWithTarget(self, action: "handle_tap:")
    self.view.addGestureRecognizer(gesture)
    @snap_behavior = nil
  end

  private

  def handle_tap(gesture)
    point = gesture.locationInView(view)
    animator.removeBehavior(@snap_behavior)
    @snap_behavior = UISnapBehavior.alloc.initWithItem(box, snapToPoint: point)
    animator.addBehavior(@snap_behavior)
  end

  def create_instructions_label
    @label ||= UILabel.alloc.initWithFrame([[20, 504], [280, 44]]).tap do |lbl|
      lbl.enabled = false
      lbl.contentMode = UIViewContentModeLeft
      lbl.clipsToBounds = true
      lbl.text = 'Click Anywhere to have box move.'
      lbl.adjustsFontSizeToFitWidth = true
      lbl.font = UIFont.fontWithName('Chalkduster', size:15)
    end
  end
end