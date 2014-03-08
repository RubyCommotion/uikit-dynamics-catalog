class ContinuousPushViewController < BaseViewController

  attr_accessor :square1, :animator, :push_behavior


  def loadView
    self.view = DecorationView.alloc.init
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
			self.animator = UIDynamicAnimator.alloc.initWithReferenceView(self.view)
      collision_behavior = UICollisionBehavior.alloc.initWithItems([square1])
      # Account for any top and bottom bars when setting up the reference bounds.
      collision_behavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(self.topLayoutGuide.length, 0,
                                                                                             self.bottomLayoutGuide.length, 0))
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
      p = gesture.locationInView(self.view)
      o = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
      distance = Math.sqrt(((p.x-o.x) ** 2.0) + ((p.y-o.y) ** 2.0))
      angle = Math.atan2(p.y-o.y, p.x-o.x)
      distance = [distance, 200.0].min
  
      # Display an arrow showing the direction and magnitude of the applied force.
      self.view.drawMagnitudeVectorWithLength(distance, angle: angle, color: UIColor.redColor, forLimitedTime: false)
  
      # These two lines change the actual force vector.
      push_behavior.setMagnitude(distance / 100.0)
      push_behavior.setAngle(angle)
  end

  private

  def create_gesture_recognizer
    tap_gesture_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'handle_push_continuous_gesture:')
    self.view.addGestureRecognizer(tap_gesture_recognizer)
  end



  def create_square1_view
    @square1 ||= UIView.alloc.initWithFrame([[110, 98], [100, 100]]).tap do |sq1_view|
      sq1_view.userInteractionEnabled = false
      box1_view = new_box(0,0)
      box1_view.accessibilityLabel = 'Is a box'
      sq1_view.addSubview(box1_view)
      sq1_view.accessibilityLabel = 'Square contains a box'
      self.view.addSubview(sq1_view)
    end


    def create_origin_view
      origin_image = UIImage.imageNamed('origin')
      origin_view = UIImageView.alloc.initWithFrame([[155, 235], [10, 10]])
      origin_view.image = origin_image
      origin_view.accessibilityLabel = 'Is an origin'
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

  end

end
