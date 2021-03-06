describe CustomDynamicItemViewController do

  before do
    @help_methods = SpecHelper.create_help_methods
    @button = controller.send(:create_button)
  end

  tests CustomDynamicItemViewController

  def controller
    @controller ||= CustomDynamicItemViewController.alloc.init(DecorationView.alloc.init)
  end


  it 'should create two ivars @button_bounds and @target' do
    button = controller.send(:create_button)
    ptbm = ResizableDynamicItemModule::PositionToBoundsMapping.alloc.initWithTarget(button)

    SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@button_bounds'), :ivar_class => CGRect},
                                       {:ivar_instance => ptbm.instance_variable_get('@target'), :ivar_class => UIButton}
                                     ])
  end


  describe 'CustomDynamicItemViewController #loadView' do

    it 'should create a root view using instance of injected class DecorationView' do
      controller.view.class.should.equal DecorationView
    end
  end

  describe 'CustomDynamicItemViewController #viewDidLoad' do
    it 'should create a button' do
     view('Tap Me').class.should.equal UIButton
    end

    it 'should add the button to view as a controller view subview'do
    controller.view.subviews[1].accessibilityLabel.should.equal 'Tap Me'
    end

    it 'should have the button fill its content rectangle horizontally and vertically.'do
      controller.view.subviews[1].contentHorizontalAlignment.should.equal UIControlContentHorizontalAlignmentFill
      controller.view.subviews[1].contentVerticalAlignment.should.equal UIControlContentVerticalAlignmentFill
    end

    it 'should assign the button\'s bounds to the attr_accessor button_bounds.'do
      controller.instance_variable_get('@button_bounds').origin.x.should.equal 0.0
      controller.instance_variable_get('@button_bounds').origin.y.should.equal 0.0
      controller.instance_variable_get('@button_bounds').size.width.should.equal 150.0
      controller.instance_variable_get('@button_bounds').size.height.should.equal 46.0
    end
  end

  describe 'CustomDynamicItemViewController #button_action' do

    it 'should create a UIAttachmentBehavior and add it to a UIDynamicAnimator.'do
      controller.send(:create_attachment_behaviour, @button)
      controller.animator.behaviors[0].class.should.equal UIAttachmentBehavior
    end

    it 'should have a UIAttachmentBehavior with an anchorPoint that is equal to the button\'s centre' do
      controller.animator.behaviors[0].anchorPoint.x.round.should.equal @button.center.x.round # take care of any float rounding issues
      controller.animator.behaviors[0].anchorPoint.y.round.should.equal @button.center.y.round
    end

    it 'should have a UIAttachmentBehavior with a frequency of 2.0 and damping of 0.3.'do
      controller.send(:create_push_behaviour, @button)
      controller.animator.behaviors[0].frequency.should.equal 2.0
      controller.animator.behaviors[0].damping.should.equal 0.3
    end


    it 'should create a UIPushBehavior with mode UIPushBehaviorModeInstantaneous and add it to a UIDynamicAnimator.'do
      controller.send(:create_push_behaviour, @button)
      controller.animator.behaviors[1].class.should.equal UIPushBehavior
      controller.animator.behaviors[1].mode.should.equal UIPushBehaviorModeInstantaneous
    end

    it 'should have a UIPushBehavior with an angle of Math::PI/4.0 and magnitude of 2.0.'do
      controller.send(:create_push_behaviour, @button)
      controller.animator.behaviors[1].angle.should.equal Math::PI/4.0
      controller.animator.behaviors[1].magnitude.should.equal 2.0
    end
  end

  describe 'PositionToBoundsMapping (a protocol class) is accessed by CustomDynamicItemViewController via its instance object button_bounds_dynamic_item' do

    #TODO can this be refactored?
    it 'should have been used to create an instance of itself by CustomDynamicItemViewController.'do
      pos_to_bounds_mapping = controller.send(:create_bb_dynamic_item, @button)
      pos_to_bounds_mapping.class.should.equal ResizableDynamicItemModule::PositionToBoundsMapping
      @button.center.x.should !=  pos_to_bounds_mapping.center.x
      @button.center.y.should !=  pos_to_bounds_mapping.center.y
    end

    it 'should have an attr_accessor :target and the protocol methods bounds, setBounds, center, setCenter, transform, setTransform ' do
      @button_bounds_dynamic_item = controller.send(:button_action, @button)
      @help_methods.do_methods_respond(@button_bounds_dynamic_item, :bounds, :setBounds, :center, :setCenter,
                                       :transform, :setTransform ).should.equal 'All Methods responded'
    end

    it 'should return the button bounds via #bounds' do
      @button_bounds_dynamic_item.bounds.origin.x.should.equal 0.0
      @button_bounds_dynamic_item.bounds.origin.y.should.equal 0.0
      @button_bounds_dynamic_item.bounds.size.width.should.be.close (150.0, 15.0) # for given attachment behaviour and push behaviour
      @button_bounds_dynamic_item.bounds.size.height.should.be.close (46.0, 8.0)  # dampening, frequency, magnitude and angle
    end

    it 'should return true via #setBounds' do
      @button_bounds_dynamic_item.setBounds.should.equal true
    end

    it 'should return a CGPoint object via #center' do
      @button_bounds_dynamic_item.center.class.should.equal CGPoint
    end

    it 'should return a CGAffineTransform object via #transform' do
      transform_snapshot = @button_bounds_dynamic_item.transform
      transform_snapshot.class.should.equal CGAffineTransform
      (transform_snapshot.a == 1.0 && transform_snapshot.d == 1.0 && transform_snapshot.tx == 0.0 && transform_snapshot.ty == 0.0).should.equal true
      (transform_snapshot.b > -10.0 && transform_snapshot.b <= 0.0).should.equal true
      (transform_snapshot.c >= 0.0 && transform_snapshot.c <= 10.0).should.equal true
    end

    it 'should return a CGAffineTransform object via #setTransform' do
      transform_snapshot = @button_bounds_dynamic_item.transform
      set_transform_snapshot = @button_bounds_dynamic_item.setTransform(transform_snapshot)
      set_transform_snapshot.class.should.equal CGAffineTransform
      (set_transform_snapshot.a == 1.0 && set_transform_snapshot.d == 1.0 && set_transform_snapshot.tx == 0.0 && set_transform_snapshot.ty == 0.0).should.equal true
      (set_transform_snapshot.b > -10.0 && set_transform_snapshot.b <= 0.0).should.equal true
      (set_transform_snapshot.c >= 0.0 && set_transform_snapshot.c <= 10.0).should.equal true
    end
  end
end