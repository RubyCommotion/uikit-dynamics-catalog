class InstantaneousPushViewController  < BaseViewController

  attr_accessor :square1, :animator, :push_behavior


  def loadView
    self.view = DecorationView.alloc.init
  end


  def viewDidLoad
    super
    create_square1_view
    create_origin_view
    create_instructions_label
  end


  def viewDidAppear(animated)
    super

    self.animator = UIDynamicAnimator.alloc.initWithReferenceView(self.view)

    collisionBehavior = UICollisionBehavior.alloc.initWithItems([square1])
    # Account for any top and bottom bars when setting up the reference bounds.
    collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0))
    animator.addBehavior(collisionBehavior)

    push_behavior = UIPushBehavior.alloc.initWithItems([square1], mode:UIPushBehaviorModeInstantaneous)
    push_behavior.angle = 0.0
    push_behavior.magnitude = 0.0
    animator.addBehavior(push_behavior)
    #self.push_behavior = push_behavior
    #self.animator = animator
  end


  #  IBAction for the Tap Gesture Recognizer that has been configured to track
  #  touches in self.view.
  #def handlePushGesture:(UITapGestureRecognizer*)gesture
  #{
  #    # Tapping will change the angle and magnitude of the impulse. To visually
  #    # show the impulse vector on screen, a red arrow representing the angle
  #    # and magnitude of this vector is briefly drawn.
  #    CGPoint p = [gesture locationInView:self.view]
  #    CGPoint o = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
  #    CGFloat distance = sqrtf(powf(p.x-o.x, 2.0)+powf(p.y-o.y, 2.0))
  #    CGFloat angle = atan2(p.y-o.y, p.x-o.x)
  #    distance = MIN(distance, 100.0)
  #
  #    # Display an arrow showing the direction and magnitude of the applied
  #    # impulse.
  #    [(APLDecorationView*)self.view drawMagnitudeVectorWithLength:distance angle:angle color:[UIColor redColor] forLimitedTime:true]
  #
  #    # These two lines change the actual force vector.
  #    [self.push_behavior setMagnitude:distance / 100.0]
  #    [self.push_behavior setAngle:angle]
  #    # A push behavior in instantaneous (impulse) mode automatically
  #    # deactivate itself after applying the impulse. We thus need to reactivate
  #    # it when changing the impulse vector.
  #    [self.push_behavior setActive:TRUE]
  #end

  private

  def create_square1_view
    @square1 ||= UIView.alloc.initWithFrame([[110, 98], [100, 100]]).tap do |sq1_view|
      sq1_view.userInteractionEnabled = false
      box1_view = new_box(0,0)
      sq1_view.addSubview(box1_view)
      self.view.addSubview(sq1_view)
      #attachment_point_mask_image = UIImage.imageNamed('attachment_point_mask')
      #self.square1_attachment_view = UIImageView.alloc.initWithFrame([[44, 44], [attachment_point_mask_image.size.height, attachment_point_mask_image.size.width]])
      #square1_attachment_view.image = attachment_point_mask_image
      #square1_attachment_view.center = CGPointMake(25.0, 25.0)
      #square1_attachment_view.tintColor = UIColor.blueColor
      #square1_attachment_view.image = square1_attachment_view.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
      #sq1_view.addSubview(square1_attachment_view)
    end


    def create_origin_view
      origin_image = UIImage.imageNamed('origin')
      origin_view = UIImageView.alloc.initWithFrame([[155, 235], [10, 10]])
      origin_view.image = origin_image
      #square1_attachment_view.center = CGPointMake(25.0, 25.0)
      #square1_attachment_view.tintColor = UIColor.blueColor
      #square1_attachment_view.image = square1_attachment_view.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
      self.view.addSubview(origin_view)
    end

    def create_instructions_label
      label ||= UILabel.alloc.initWithFrame([[20, 439], [280, 21]]).tap do |lbl|
        lbl.enabled = false
        lbl.contentMode = UIViewContentModeLeft
        lbl.clipsToBounds = true
        lbl.text = 'Tap anywhere to create a force.'
        lbl.adjustsFontSizeToFitWidth = true
        #lbl.textColor = UIColor.darkTextColor
        lbl.font = UIFont.fontWithName('Chalkduster', size:15)
      end
      self.view.addSubview(label)
    end

  end

end