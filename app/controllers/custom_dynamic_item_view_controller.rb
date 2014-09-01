class CustomDynamicItemViewController < UIViewController
  include BaseModule, ResizableDynamicItemModule

  def init(decorator_view)
    @decorator_view = decorator_view
    self
  end

  def loadView
    self.view = @decorator_view
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
    button = create_button
    self.view.addSubview(button)
    @button_bounds = button.bounds
    # Force the button image to scale with its bounds.
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill
  end


  private

  def button_action(sender)
    # Reset the buttons bounds to their initial state.  See the comment in viewDidLoad.
    button_bounds_dynamic_item = create_bb_dynamic_item(sender)

    # Create an attachment between the button_bounds_dynamic_item and the initial
    # value of the button's bounds.
    create_attachment_behaviour(button_bounds_dynamic_item)
    create_push_behaviour(button_bounds_dynamic_item)
    button_bounds_dynamic_item
  end

  def create_bb_dynamic_item(sender)
    sender.bounds = @button_bounds
    # UIDynamicAnimator instances are relatively cheap to create.
    # PositionToBoundsMapping maps the center of an id<ResizableDynamicItem>
    # (UIDynamicItem with mutable bounds) to its bounds.  As dynamics modifies
    # the center.x, the changes are forwarded to the bounds.size.width.
    # Similarly, as dynamics modifies the center.y, the changes are forwarded
    # to bounds.size.height.
    PositionToBoundsMapping.alloc.initWithTarget(sender)
  end

  def create_attachment_behaviour(button_bounds_dynamic_item)
    centre_pt = button_bounds_dynamic_item.center
    attachment_behavior = UIAttachmentBehavior.alloc.initWithItem(button_bounds_dynamic_item, attachedToAnchor:centre_pt)
    attachment_behavior.setFrequency(2.0)
    attachment_behavior.setDamping(0.3)
    animator.addBehavior(attachment_behavior)
  end

  def create_push_behaviour(button_bounds_dynamic_item)
    push_behavior = UIPushBehavior.alloc.initWithItems([button_bounds_dynamic_item], mode:UIPushBehaviorModeInstantaneous)
    push_behavior.angle = Math::PI/4.0
    push_behavior.magnitude = 2.0
    animator.addBehavior(push_behavior)
    push_behavior.setActive(true)
  end

  def create_button
      button_background = UIImage.imageNamed( 'button_outline.png' )
      @rounded_button_type ||= UIButton.buttonWithType( UIButtonTypeRoundedRect ).tap do |button|
        button.frame = [ [ 85.0, 259.0 ], [ 150, 46 ] ]
        button.setBackgroundImage( button_background, forState: UIControlStateNormal )
        button.addTarget( self,
                          action: 'button_action:',
                          forControlEvents: UIControlEventTouchUpInside )
        button.setAccessibilityLabel('Tap Me')
      end
  end
end
