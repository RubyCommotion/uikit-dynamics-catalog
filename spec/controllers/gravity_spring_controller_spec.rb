describe GravitySpringController do

  tests GravitySpringController

  def controller
    @controller ||= GravitySpringController.alloc.init(DecorationView.alloc.init)
  end

  describe 'GravitySpringController #loadView' do
    it 'should create a self.view using instance of class DecorationView' do
      controller.view.class.should.equal DecorationView
    end
  end

  describe 'GravitySpringController #viewDidLoad' do
    it 'should create the ivars @decorator_view and @attachment' do

      SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@decorator_view'), :ivar_class => DecorationView},
                                          {:ivar_instance => controller.instance_variable_get('@attachment'), :ivar_class => UIAttachmentBehavior}
                                         ])
    end

    it 'should create an arrow UIImageView' do
      controller.view.subviews[0].accessibilityLabel.should.equal 'Arrow'
      controller.view.subviews[0].class.should.equal UIImageView
    end

    it 'should create an label' do
      controller.view.subviews[1].accessibilityLabel.should.equal 'Drag circle'
      controller.view.subviews[1].class.should.equal UILabel
    end

    it 'should create a square UIView as a controller subview' do
      controller.view.subviews[2].accessibilityLabel.should.equal 'Square'
      controller.view.subviews[2].class.should.equal NSKVONotifying_UIView
    end

    it 'should add two subviews to the square ImageView ' do
          view('Square').subviews.count.should.equal 2
        end

    it 'should add a UIImageView subview box to square' do
      view('Square').subviews[0].accessibilityLabel.should.equal 'Box'
      view('Square').subviews[0].class.should.equal UIImageView
    end

    it 'should add a UIImageView subview square_attachment_view to square' do
      view('Square').subviews[1].accessibilityLabel.should.equal 'Square Attachment View'
      view('Square').subviews[1].class.should.equal UIImageView
    end

    it 'should add attachment_view UIImageView as a controller subview' do
      controller.view.subviews[3].accessibilityLabel.should.equal 'Attachment View'
      controller.view.subviews[3].class.should.equal NSKVONotifying_UIImageView
    end

    it 'should create an animator' do
      controller.animator.class.should == UIDynamicAnimator
    end

    it 'should add three behaviors to the controller view' do
      controller.animator.behaviors.count.should.equal 3
      controller.animator.behaviors[0].class.should == UIAttachmentBehavior
      controller.animator.behaviors[1].class.should == UICollisionBehavior
      controller.animator.behaviors[1].collisionMode.should == UICollisionBehaviorModeEverything
      controller.animator.behaviors[1].items.count.should == 1
      controller.animator.behaviors[2].class.should == UIGravityBehavior
    end

    it 'should have a UIAttachmentBehavior with a frequency of 1.0 and damping of 0.1.'do
      controller.animator.behaviors[0].frequency.should.equal 1.0
      controller.animator.behaviors[0].damping.should.equal 0.1
    end

    it 'should add a panGestureRecognizer for the controller view' do
      controller.view.gestureRecognizers.count.should.equal 1
      controller.view.gestureRecognizers[0].class.should == UIPanGestureRecognizer
    end

    it 'should create an observer for DecorationView\'s attachment_point_view object\'s centre method' do
      should.not.raise(NSRangeException) {controller.view.attachment_point_view.removeObserver(controller.view, forKeyPath: 'center') }
      should.raise(NSRangeException) {controller.view.attachment_point_view.removeObserver(controller.view, forKeyPath: 'center') }
    end

    it 'should create an observer for DecorationView\'s attached_view object\'s centre method' do
      should.not.raise(NSRangeException) {controller.view.attached_view.removeObserver(controller.view, forKeyPath: 'center') }
      should.raise(NSRangeException) {controller.view.attached_view.removeObserver(controller.view, forKeyPath: 'center') }
    end
  end

  describe 'GravitySpringController UIPanGestureRecognizer action method #handle_attachment_gesture.' do

    it 'should set the attachment_behavior\'s anchorPoint.' do
      (controller.instance_variable_get('@attachment').anchorPoint.x == 0.0 && controller.instance_variable_get('@attachment').anchorPoint.y == 0.0).should.equal false
      gesture = controller.view.gestureRecognizers[0]
      controller.send(:handle_attachment_gesture, gesture)
      (controller.instance_variable_get('@attachment').anchorPoint.x == 0.0 && controller.instance_variable_get('@attachment').anchorPoint.y == 0.0).should.equal true
    end

    it 'should set the attachment_view\'s center to be equal to the anchorPoint center.' do
      (controller.instance_variable_get('@attachment_view').center.x == controller.instance_variable_get('@attachment').anchorPoint.x).should.equal true
      (controller.instance_variable_get('@attachment_view').center.y == controller.instance_variable_get('@attachment').anchorPoint.y).should.equal true
    end
  end
end



