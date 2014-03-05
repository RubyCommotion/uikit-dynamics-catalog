class InstantaneousPushViewController  < UIViewController

  attr_accessor :square1, :animator, :push_behavior


  def loadView
    self.view = DecorationView.alloc.init
  end


  def viewDidLoad
    super

  end


  def viewDidAppear(animated)
    super

    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view]

    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.square1]]
    # Account for any top and bottom bars when setting up the reference bounds.
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)]
    [animator addBehavior:collisionBehavior]

    UIPushBehavior *push_behavior = [[UIPushBehavior alloc] initWithItems:@[self.square1] mode:UIPushBehaviorModeInstantaneous]
    push_behavior.angle = 0.0
    push_behavior.magnitude = 0.0
    [animator addBehavior:push_behavior]
    self.push_behavior = push_behavior

    self.animator = animator
  end


  #  IBAction for the Tap Gesture Recognizer that has been configured to track
  #  touches in self.view.
  def handlePushGesture:(UITapGestureRecognizer*)gesture
  {
      # Tapping will change the angle and magnitude of the impulse. To visually
      # show the impulse vector on screen, a red arrow representing the angle
      # and magnitude of this vector is briefly drawn.
      CGPoint p = [gesture locationInView:self.view]
      CGPoint o = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
      CGFloat distance = sqrtf(powf(p.x-o.x, 2.0)+powf(p.y-o.y, 2.0))
      CGFloat angle = atan2(p.y-o.y, p.x-o.x)
      distance = MIN(distance, 100.0)

      # Display an arrow showing the direction and magnitude of the applied
      # impulse.
      [(APLDecorationView*)self.view drawMagnitudeVectorWithLength:distance angle:angle color:[UIColor redColor] forLimitedTime:true]

      # These two lines change the actual force vector.
      [self.push_behavior setMagnitude:distance / 100.0]
      [self.push_behavior setAngle:angle]
      # A push behavior in instantaneous (impulse) mode automatically
      # deactivate itself after applying the impulse. We thus need to reactivate
      # it when changing the impulse vector.
      [self.push_behavior setActive:TRUE]
  end

end