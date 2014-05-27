class InstantaneousPushViewController  < UIViewController
  include BaseModule

  def init(decorator_view)
    @decorator_view = decorator_view
    self
  end

  def loadView
    self.view = @decorator_view
    self.view.accessibilityLabel = 'This is main view'
  end


  def viewDidLoad
    super
    create_gesture_recognizer
    create_square1_view
    create_origin_view
    create_instructions_label
  end


  def viewDidAppear(animated)
    super

    collisionBehavior = UICollisionBehavior.alloc.initWithItems([square1])
    # Account for any top and bottom bars when setting up the reference bounds.
    collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(self.topLayoutGuide.length,
                                                                                          0,
                                                                                          self.bottomLayoutGuide.length,
                                                                                          0)
    )
    animator.addBehavior(collisionBehavior)

    self.push_behavior = UIPushBehavior.alloc.initWithItems([square1], mode:UIPushBehaviorModeInstantaneous)
    push_behavior.angle = 0.0
    push_behavior.magnitude = 0.0
    animator.addBehavior(push_behavior)
  end


  def handle_instantaneous_push_gesture(gesture)
    # Tapping will change the angle and magnitude of the impulse. To visually show the impulse vector on screen, a red arrow representing the angle
    # and magnitude of this vector is briefly drawn.

    set_distance_and_angle(gesture)

    # Display an arrow showing the direction and magnitude of the applied impulse.
    self.view.drawMagnitudeVectorWithLength(distance, angle: angle, color: UIColor.redColor, forLimitedTime: true)

    # These two lines change the actual force vector.
    push_behavior.setMagnitude(distance / 100.0)
    push_behavior.setAngle(angle)
    # A push behavior in instantaneous (impulse) mode automatically deactivate itself after applying the impulse. We thus need to reactivate
    # it when changing the impulse vector.
    push_behavior.setActive(true)
  end

  protected
  attr_accessor :square1, :push_behavior, :distance, :angle

  private

  def create_gesture_recognizer
    tap_gesture_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'handle_instantaneous_push_gesture:')
    self.view.addGestureRecognizer(tap_gesture_recognizer)
  end


  def create_square1_view
    @square1 ||= UIView.alloc.initWithFrame([[110, 98], [100, 100]]).tap do |sq1_view|
      sq1_view.userInteractionEnabled = false
      sq1_view.setAccessibilityLabel('Square')
      box1_view = new_box(0,0)
      box1_view.setAccessibilityLabel('Box')
      sq1_view.addSubview(box1_view)
      self.view.addSubview(sq1_view)
    end
  end


  def create_origin_view
    origin_image = UIImage.imageNamed('origin')
    origin_view = UIImageView.alloc.initWithFrame([[155, 235], [10, 10]])
    origin_view.image = origin_image
    origin_view.setAccessibilityLabel('Origin')
    self.view.addSubview(origin_view)
  end

  def create_instructions_label
    label ||= UILabel.alloc.initWithFrame([[20, 439], [280, 21]]).tap do |lbl|
      lbl.enabled = false
      lbl.contentMode = UIViewContentModeLeft
      lbl.clipsToBounds = true
      lbl.text = 'Tap anywhere to create a force'
      lbl.adjustsFontSizeToFitWidth = true
      lbl.font = UIFont.fontWithName('Chalkduster', size:15)
    end
    self.view.addSubview(label)
  end

  def set_distance_and_angle(gesture)
    p = gesture.locationInView(self.view)
    o = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
    self.distance = Math.sqrt(((p.x - o.x) ** 2.0) + ((p.y - o.y) ** 2.0))
    self.angle = Math.atan2(p.y-o.y, p.x-o.x)
    self.distance = [distance, 100.0].min
  end
end