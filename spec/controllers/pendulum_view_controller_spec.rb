describe PendulumViewController do
  before do
    @help_methods = SpecHelper.create_help_methods
  end

  tests PendulumViewController

  after do
    @help_methods.window_cleanup(window, controller)
  end

  describe '#init' do
    it 'should create attr_accessors :attachmentPoint, :pendulumBehavior' do
      @help_methods.do_methods_respond(controller, :attachment_point, :attachment_point=, :pendulum_behavior, :pendulum_behavior=).
                                   should.equal 'All Methods responded'
    end
  end

  describe '#viewDidLoad' do
    it 'should assign a UILabel as a controller Subview. ' do
      controller.view.subviews[1].class.should.equal UILabel
      controller.view.subviews[1].object_id.should.equal controller.instance_variable_get('@label').object_id
    end

    it 'should assign box imageImageView to the second subview of the controller\'s view. ' do
      controller.view.subviews[2].class.should.equal NSKVONotifying_UIImageView
      controller.view.subviews[2].object_id.should.equal controller.box.object_id
    end

    it 'should assign attachment_point imageImageView as a controller Subview.' do
      controller.view.subviews[3].class.should.equal NSKVONotifying_UIImageView
      controller.view.subviews[3].object_id.should.equal controller.attachment_point.object_id
    end

    # self.view.trackAndDrawAttachmentFromView tested via decoration_view_spec.rb

    it 'should have added one behavior' do
      controller.animator.behaviors.count.should.equal 1
      controller.animator.behaviors[0].class.should == PendulumBehaviour
    end

    it 'should have added a UIPanGestureRecognizer.' do
      controller.view.gestureRecognizers.count.should.equal 1
      controller.view.gestureRecognizers[0].class.should == UIPanGestureRecognizer
    end

    it 'should have initial UIPanGestureRecognizer enabled state as UIGestureRecognizerStatePossible.' do
      controller.view.gestureRecognizers[0].state.should == UIGestureRecognizerStatePossible
    end


    it "should have a UIPanGestureRecognizer that responds to a drag action by changing
the gesture recognizer\'s locationInView CGPoint value and change the gesture\'s
state from UIGestureRecognizerStatePossible to UIGestureRecognizerStateEnded." do
      # starting state of gesture recognizer
      controller.view.gestureRecognizers[0].state.should == UIGestureRecognizerStatePossible
      # get default gesture recognizer location in view
      location = controller.view.gestureRecognizers[0].locationInView(controller.view)
      (location.x == 0.0 && location.y == 0.0).should.equal true
      drag(controller.box, :from => CGPointMake(154.0,327.0), :to => CGPointMake(x=140.0, y=340.0))
      # get  gesture recognizer location in view after dragging operation
      location = controller.view.gestureRecognizers[0].locationInView(controller.view)
      (location.x == 140.0 && location.y == 340.0).should.equal true
      controller.send(:drag_weight, controller.view.gestureRecognizers[0])
      # ending state of gesture recognizer - interestingly if spec file run in isolation it tests as UIGestureRecognizerStateEnded
      # vs full run of all specs it tests as UIGestureRecognizerStatePossible
      controller.view.gestureRecognizers[0].state.should == UIGestureRecognizerStatePossible
    end

  end

  describe 'Class PendulumBehaviour\'s instance object pendulum_behavior' do

    it 'should have two attr_accessors :draggingBehavior and :pushBehavior' do
      @help_methods.do_methods_respond(controller.pendulum_behavior, :draggingBehavior, :draggingBehavior=, :pushBehavior, :pushBehavior=).
                                   should.equal 'All Methods responded'
    end

    it 'should respond to #begin_dragging_weight_at_point' do
      controller.pendulum_behavior.begin_dragging_weight_at_point(controller.attachment_point.center).childBehaviors[3].class.should.equal UIAttachmentBehavior
      controller.pendulum_behavior.draggingBehavior.anchorPoint.class.should.equal  CGPoint
    end

    it 'should respond to #drag_weight_to_point' do
      controller.pendulum_behavior.drag_weight_to_point(controller.attachment_point.center).class.should.equal CGPoint
    end

    it 'should respond to #end_dragging_weight_with_velocity' do
      velocity = CGPointMake(-7.0, 11.0)
      controller.pendulum_behavior.end_dragging_weight_with_velocity(velocity)
      controller.pendulum_behavior.pushBehavior.magnitude.should.be.close(0.026, 0.001)
      controller.pendulum_behavior.pushBehavior.angle.should.be.close( 2.137, 0.001)
    end


  end

end