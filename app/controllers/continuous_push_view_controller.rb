class ContinuousPushViewController < UIViewController
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
    collision_behavior = UICollisionBehavior.alloc.initWithItems([square1])
    # Account for any top and bottom bars when setting up the reference bounds.
    collision_behavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(
      UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
    )
    animator.addBehavior(collision_behavior)

    self.push_behavior = UIPushBehavior.alloc.initWithItems([self.square1], mode:UIPushBehaviorModeContinuous)
    push_behavior.angle = 0.0
    push_behavior.magnitude = 0.0
    animator.addBehavior(push_behavior)
  end

  
  
  def handle_push_continuous_gesture(gesture)
    # Tapping in the view changes the angle and magnitude of the force. To
    # visually show the force vector on screen, a red arrow is drawn
    # representing the angle and magnitude of this vector. The force is
    # continuously applied while the behavior is active, so we keep the vector
    # line visible and just update its size and rotation to represent the
    # vector.
    set_distance_and_angle(gesture)

    # Display an arrow showing the direction and magnitude of the applied force.
    self.view.drawMagnitudeVectorWithLength(distance, angle: angle, color: UIColor.redColor, forLimitedTime: false)

    # These two lines change the actual force vector.
    push_behavior.setMagnitude(distance / 100.0)
    push_behavior.setAngle(angle)
  end

  protected

  attr_accessor :square1, :push_behavior, :distance, :angle

  private

  def create_gesture_recognizer
    tap_gesture_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'handle_push_continuous_gesture:')
    self.view.addGestureRecognizer(tap_gesture_recognizer)
  end


  def create_square1_view
    @square1 ||= UIView.alloc.initWithFrame([[110, 98], [100, 100]]).tap do |sq1_view|
      sq1_view.userInteractionEnabled = false
      box1_view = new_box(0,0)
      box1_view.setAccessibilityLabel('Box')
      sq1_view.addSubview(box1_view)
      sq1_view.setAccessibilityLabel('Square')
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
    self.distance = Math.sqrt(((p.x-o.x) ** 2.0) + ((p.y-o.y) ** 2.0))
    self.angle = Math.atan2(p.y-o.y, p.x-o.x)
    self.distance = [distance, 200.0].min
  end
end
