describe AttachmentsView do

  tests AttachmentsView

  def controller
    @controller ||= AttachmentsView.alloc.init(DecorationView.alloc.init)
  end

  describe 'AttachmentsView' do


    it 'should create five ivars @collision_behavior, @attachment_behavior, @square1, @sq1_attachment_image_view, @attachment_view' do
    SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@collision_behavior'), :ivar_class => UICollisionBehavior},
                                        {:ivar_instance => controller.instance_variable_get('@attachment_behavior'), :ivar_class => UIAttachmentBehavior},
                                        {:ivar_instance => controller.instance_variable_get('@square1'), :ivar_class => NSKVONotifying_UIView},
                                        {:ivar_instance => controller.instance_variable_get('@sq1_attachment_image_view'), :ivar_class => UIImageView},
                                        {:ivar_instance => controller.instance_variable_get('@attachment_view'), :ivar_class => NSKVONotifying_UIImageView}
                                       ])

    end
  end


  describe 'AttachmentsView #loadView' do
    it 'should create a self.view using an injected DecorationView instance' do
      controller.view.class.should.equal DecorationView
    end
  end

  describe 'AttachmentsView #viewDidLoad' do

    it 'should add four subviews to the controller view.' do
       controller.view.subviews.count.should.equal 4
    end

    it 'should add an arrow UIImageView as a controller subview' do
      controller.view.subviews[0].accessibilityLabel.should.equal 'Arrow'
      controller.view.subviews[0].class.should.equal UIImageView
    end

    it 'should add square1 UIView as a controller subview' do
      controller.view.subviews[1].accessibilityLabel.should.equal 'Square'
      controller.view.subviews[1].class.should.equal NSKVONotifying_UIView
    end

    it 'should add two subviews to the square1 ImageView ' do
      view('Square').subviews.count.should.equal 2
    end

    it 'should add an UIImageView subview box1 to square1' do
      view('Square').subviews[0].accessibilityLabel.should.equal 'Box'
      view('Square').subviews[0].class.should.equal UIImageView
    end

    it 'should add an UIImageView subview sq1_attachment_image_view to square1' do
      view('Square').subviews[1].accessibilityLabel.should.equal 'Square Attachment View'
      view('Square').subviews[1].class.should.equal UIImageView
    end

    it 'should add UILabel as a controller subview' do
      controller.view.subviews[2].accessibilityLabel.should.equal 'Drag red circle to move the square.'
      controller.view.subviews[2].class.should.equal UILabel
    end

    it 'should add attachment_view UIImageView as a controller subview' do
      controller.view.subviews[3].accessibilityLabel.should.equal 'Attachment View'
      controller.view.subviews[3].class.should.equal NSKVONotifying_UIImageView
    end

    it 'should add a panGestureRecognizer for the controller view' do
      controller.view.gestureRecognizers.count.should.equal 1
      controller.view.gestureRecognizers[0].class.should == UIPanGestureRecognizer
    end

    it 'should create an animator' do
      controller.animator.class.should == UIDynamicAnimator
    end

    it 'should add two behaviors to the controller view' do
      controller.animator.behaviors.count.should.equal 2
      controller.animator.behaviors[0].class.should == UICollisionBehavior
      controller.animator.behaviors[0].collisionMode.should == UICollisionBehaviorModeEverything
      controller.animator.behaviors[1].class.should == UIAttachmentBehavior
      controller.animator.behaviors[1].items.count.should == 1
    end

    it 'should create an observer for DecorationView\'s attachment_point_view object\'s centre method' do
      should.not.raise(NSRangeException) {controller.view.attachment_point_view.removeObserver(controller.view, forKeyPath: 'center') }
      # should.raise(NSRangeException) {controller.view.attachment_point_view.removeObserver(controller.view, forKeyPath: 'not_center') }
    end

    it 'should create an observer for DecorationView\'s attached_view object\'s centre method' do
      should.not.raise(NSRangeException) {controller.view.attached_view.removeObserver(controller.view, forKeyPath: 'center') }
      # should.raise(NSRangeException) {controller.view.attached_view.removeObserver(controller.view, forKeyPath: 'not_center') }
    end

  end

  describe 'AttachmentsView UIPanGestureRecognizer action method #handle_attachment_gesture.' do

    it 'should set the attachment_behavior\'s anchorPoint.' do
      (controller.instance_variable_get('@attachment_behavior').anchorPoint.x == 0.0 && controller.instance_variable_get('@attachment_behavior').anchorPoint.y == 0.0).should.equal false
      gesture = controller.view.gestureRecognizers[0]
      controller.send(:handle_attachment_gesture, gesture)
      (controller.instance_variable_get('@attachment_behavior').anchorPoint.x == 0.0 && controller.instance_variable_get('@attachment_behavior').anchorPoint.y == 0.0).should.equal true
    end

    it 'should set the attachment_view\'s center to be equal to the anchorPoint center.' do
      (controller.instance_variable_get('@attachment_view').center.x == controller.instance_variable_get('@attachment_behavior').anchorPoint.x).should.equal true
      (controller.instance_variable_get('@attachment_view').center.y == controller.instance_variable_get('@attachment_behavior').anchorPoint.y).should.equal true
    end
  end
end
