class CustomDynamicItemViewController < BaseViewController


  def loadView
    self.view = DecorationView.alloc.init
  end

  def viewDidLoad
    # Save the button's initial bounds.  This is necessary so that the bounds
    # can be reset to their initial state before starting a new simulation.
    # Otherwise, the new simulation will continue from the bounds set in the
    # final step of the previous simulation which may have been interrupted
    # before it came to rest (e.g. the user tapped the button twice in quick
    # succession).  Without reverting to the initial bounds, this would cause
    # the button to grow uncontrollably in size.
    super
    button1 = create_button
    self.view.addSubview(button1)
    self.button1_bounds = button1.bounds
    # Force the button image to scale with its bounds.
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill
    button1.contentVerticalAlignment = UIControlContentVerticalAlignmentFill
  end


  def button_action(sender)
    # Reset the buttons bounds to their initial state.  See the comment in viewDidLoad.
    sender.bounds = button1_bounds

    # UIDynamicAnimator instances are relatively cheap to create.
    animator = UIDynamicAnimator.alloc.initWithReferenceView(self.view)

    # APLPositionToBoundsMapping maps the center of an id<ResizableDynamicItem>
    # (UIDynamicItem with mutable bounds) to its bounds.  As dynamics modifies
    # the center.x, the changes are forwarded to the bounds.size.width.
    # Similarly, as dynamics modifies the center.y, the changes are forwarded
    # to bounds.size.height.
    button_bounds_dynamic_item = PositionToBoundsMapping.alloc.initWithTarget(sender)

    # Create an attachment between the button_bounds_dynamic_item and the initial
    # value of the button's bounds.

    centre_pt = button_bounds_dynamic_item.center
    attachment_behavior = UIAttachmentBehavior.alloc.initWithItem(button_bounds_dynamic_item, attachedToAnchor:centre_pt)
    attachment_behavior.setFrequency(2.0)
    attachment_behavior.setDamping(0.3)
    animator.addBehavior(attachment_behavior)

    push_behavior = UIPushBehavior.alloc.initWithItems([button_bounds_dynamic_item], mode:UIPushBehaviorModeInstantaneous)
    push_behavior.angle = Math::PI/4.0
    push_behavior.magnitude = 2.0
    animator.addBehavior(push_behavior)
    push_behavior.setActive(true)
    self.animator = animator
  end

  protected
  attr_accessor :button1, :button1_bounds, :animator

  private

  def create_button
      button_background = UIImage.imageNamed( 'button_outline.png' )
      @rounded_button_type ||= UIButton.buttonWithType( UIButtonTypeRoundedRect ).tap do |button|
        button.frame = [ [ 85.0, 259.0 ], [ 150, 46 ] ]
        button.setBackgroundImage( button_background, forState: UIControlStateNormal )
        button.addTarget( self,
                          action: 'button_action:',
                          forControlEvents: UIControlEventTouchUpInside )
      end
  end
end
