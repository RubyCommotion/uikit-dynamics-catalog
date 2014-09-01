describe PendulumViewController do
  before do
    @help_methods = SpecHelper.create_help_methods
  end

  tests PendulumViewController

  def controller
    @controller ||= PendulumViewController.alloc.init(DecorationView.alloc.init)
  end

  describe 'PendulumViewController #init' do

    it 'should create the ivars @decorator_view' do
      SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@decorator_view'), :ivar_class => DecorationView}])
    end
  end

  describe '#loadView' do
    it 'should create a root view using instance of class DecorationView' do
      controller.view.class.should.equal DecorationView
    end
  end


  describe 'PendulumViewController #viewDidLoad' do

    it 'should create the ivars @attachmentPoint and @pb' do
      SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@attachment_point'), :ivar_class => NSKVONotifying_UIImageView},
                                          {:ivar_instance => controller.instance_variable_get('@pb'), :ivar_class => PendulumBehaviour}])
    end

    it 'should assign a UILabel as a controller Subview. ' do
      controller.view.subviews[1].object_id.should.equal controller.instance_variable_get('@label').object_id
    end

    it 'should assign box imageImageView to the third subview of the controller\'s view. ' do
      controller.view.subviews[2].object_id.should.equal controller.box.object_id
    end

    it 'should assign attachment_point imageImageView as a controller Subview.' do
      controller.view.subviews[3].class.should.equal NSKVONotifying_UIImageView
      controller.view.subviews[3].object_id.should.equal controller.instance_variable_get('@attachment_point').object_id
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
the gesture recognizer\'s locationInView CGPoint value and changing the gesture\'s
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
      # ending state of gesture recognizer - if spec file run in isolation it tests as UIGestureRecognizerStateEnded
      # vs full run of all specs it tests as UIGestureRecognizerStatePossible

      state = ((controller.view.gestureRecognizers[0].state == 0) | (controller.view.gestureRecognizers[0].state == 3))
      state.should == true
    end
  end

  describe 'Class PendulumBehaviour\'s instance object pendulum_behavior' do

    it 'should have two attr_accessors :draggingBehavior and :pushBehavior' do
      @help_methods.do_methods_respond(controller.instance_variable_get('@pb'), :draggingBehavior, :draggingBehavior=, :pushBehavior, :pushBehavior=).
                                   should.equal 'All Methods responded'
    end

    it 'should respond to #begin_dragging_weight_at_point' do
      controller.instance_variable_get('@pb').begin_dragging_weight_at_point(controller.instance_variable_get('@attachment_point').center).childBehaviors[3].class.should.equal UIAttachmentBehavior
      controller.instance_variable_get('@pb').draggingBehavior.anchorPoint.class.should.equal  CGPoint
    end

    it 'should respond to #drag_weight_to_point' do
      controller.instance_variable_get('@pb').drag_weight_to_point(controller.instance_variable_get('@attachment_point').center).class.should.equal CGPoint
    end

    it 'should respond to #end_dragging_weight_with_velocity' do
      velocity = CGPointMake(-7.0, 11.0)
      controller.instance_variable_get('@pb').end_dragging_weight_with_velocity(velocity)
      # predicated on  magnitude /= 500 in class PendulumBehaviour
      controller.instance_variable_get('@pb').pushBehavior.magnitude.should.be.close(0.026, 0.001)
      controller.instance_variable_get('@pb').pushBehavior.angle.should.be.close( 2.137, 0.001)
    end
  end
end