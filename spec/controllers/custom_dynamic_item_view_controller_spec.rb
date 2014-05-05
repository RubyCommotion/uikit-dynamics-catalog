describe CustomDynamicItemViewController do

  tests CustomDynamicItemViewController

  after do
    SpecHelper.create_help_methods.window_cleanup(window, controller)
  end

  it 'should create an attr_accessor button_bounds' do
    SpecHelper.create_help_methods.do_methods_respond(controller, :button_bounds, :button_bounds=).should.equal 'All Methods responded'
  end

  describe '#loadView' do

    it 'should create a DecorationView root view' do
      controller.view.class.should.equal DecorationView
    end
  end

  describe '#viewDidLoad' do

    it 'should create a button' do
     controller.send(:create_button).class.should.equal UIButton
    end

    it 'should add the button to view as a subview'do
    controller.view.subviews[1].class.should.equal UIButton
    end

    it 'should have the button fill its content rectangle horizontally and vertically.'do
      controller.view.subviews[1].contentHorizontalAlignment.should.equal UIControlContentHorizontalAlignmentFill
      controller.view.subviews[1].contentVerticalAlignment.should.equal UIControlContentVerticalAlignmentFill
    end

    it 'should assign the button\'s bounds to the attr_accessor button_bounds.'do
      controller.button_bounds.origin.x.should.equal 0.0
      controller.button_bounds.origin.y.should.equal 0.0
      controller.button_bounds.size.width.should.equal 150.0
      controller.button_bounds.size.height.should.equal 46.0
    end
  end

  describe '#button_action' do

    before do
      @sender = controller.send(:create_button)
    end

    it 'should create an instance of NSObject class PositionToBoundsMapping.'do
      controller.send(:create_bb_dynamic_item, @sender).class.should.equal PositionToBoundsMapping
      @sender.center.x.should !=  controller.send(:create_bb_dynamic_item, @sender).center.x
      @sender.center.y.should !=  controller.send(:create_bb_dynamic_item, @sender).center.y
    end

    it 'should create a UIAttachmentBehavior and add it to a UIDynamicAnimator.'do
      controller.send(:create_attachment_behaviour, @sender)
      controller.animator.behaviors[0].class.should.equal UIAttachmentBehavior
    end

    it 'the UIAttachmentBehavior should have an anchorPoint that is equal to the button\'s centre' do
      controller.animator.behaviors[0].anchorPoint.x.round.should.equal @sender.center.x.round # take care of float rounding issues with to_i
      controller.animator.behaviors[0].anchorPoint.y.round.should.equal @sender.center.y.round # take care of float rounding issues with to_i
    end

    it 'the UIAttachmentBehavior should have a frequency of 2.0 and damping of 0.3.'do
      controller.send(:create_push_behaviour, @sender)
      controller.animator.behaviors[0].frequency.should.equal 2.0
      controller.animator.behaviors[0].damping.should.equal 0.3
    end


    it 'should create a UIPushBehavior with mode UIPushBehaviorModeInstantaneous and add it to a UIDynamicAnimator.'do
      controller.send(:create_push_behaviour, @sender)
      controller.animator.behaviors[1].class.should.equal UIPushBehavior
      controller.animator.behaviors[1].mode.should.equal UIPushBehaviorModeInstantaneous
    end

    it 'the UIPushBehavior should have an angle of Math::PI/4.0 and magnitude of 2.0.'do
      controller.send(:create_push_behaviour, @sender)
      controller.animator.behaviors[1].angle.should.equal Math::PI/4.0
      controller.animator.behaviors[1].magnitude.should.equal 2.0
    end
  end
end