describe AttachmentsView do

  tests AttachmentsView

  def controller
    @controller ||= AttachmentsView.alloc.init(DecorationView.alloc.init)
  end

  describe 'AttachmentsView #init' do

    it 'should create five attr_accessors :attachment_behavior, :square1, :box1, :sq1_attachment_image_view, :attachment_view ' do
      SpecHelper.create_help_methods.do_methods_respond(controller, :collision_behavior, :collision_behavior=,
                                   :attachment_behavior, :attachment_behavior=, :square1, :square1=,
                                   :box1, :box1=, :sq1_attachment_image_view, :sq1_attachment_image_view=, :attachment_view, :attachment_view=).
                                   should.equal 'All Methods responded'
    end
  end


  describe 'AttachmentsView #loadView' do
    it 'creates a DecorationView controller view' do
      controller.view.class.should.equal DecorationView
    end
  end

  describe 'AttachmentsView #viewDidLoad' do

    it 'added four subviews to the controller view.' do
       controller.view.subviews.count.should.equal 4
    end

    it 'added an arrow UIImageView as a controller subview' do
      view('Controller View').subviews[0].accessibilityLabel.should.equal 'Arrow'
      view('Controller View').subviews[0].class.should.equal UIImageView
    end

    it 'added square1 UIView as a controller subview' do
      view('Controller View').subviews[1].accessibilityLabel.should.equal 'Square'
      view('Controller View').subviews[1].class.should.equal NSKVONotifying_UIView
    end

    it 'added two subviews to the square1 ImageView ' do
      view('Square').subviews.count.should.equal 2
    end

    it 'added an UIImageView subview box1 to square1' do
      view('Square').subviews[0].accessibilityLabel.should.equal 'Box'
      view('Square').subviews[0].class.should.equal UIImageView
    end

    it 'added an UIImageView subview sq1_attachment_image_view to square1' do
      view('Square').subviews[1].accessibilityLabel.should.equal 'Square Attachment View'
      view('Square').subviews[1].class.should.equal UIImageView
    end

    it 'added UILabel as a controller subview' do
      view('Controller View').subviews[2].accessibilityLabel.should.equal 'Drag red circle to move the square.'
      view('Controller View').subviews[2].class.should.equal UILabel
    end

    it 'added attachment_view UIImageView as a controller subview' do
      view('Controller View').subviews[3].accessibilityLabel.should.equal 'Attachment View'
      view('Controller View').subviews[3].class.should.equal NSKVONotifying_UIImageView
    end

    it 'added a panGestureRecognizer for the controller view' do
      controller.view.gestureRecognizers.count.should.equal 1
      controller.view.gestureRecognizers[0].class.should == UIPanGestureRecognizer
    end

    it 'should create an animator' do
      controller.animator.class.should == UIDynamicAnimator
    end

    it 'added two behaviors to the controller view' do
      controller.animator.behaviors.count.should.equal 2
      controller.animator.behaviors[0].class.should == UICollisionBehavior
      controller.animator.behaviors[0].collisionMode.should == UICollisionBehaviorModeEverything
      controller.animator.behaviors[1].class.should == UIAttachmentBehavior
      controller.animator.behaviors[1].items.count.should == 1
    end


    it 'creates an observer for DecorationView\'s attachment_point_view object\'s centre method' do
      should.not.raise(NSRangeException) {controller.view.attachment_point_view.removeObserver(controller.view, forKeyPath: 'center') }
      should.raise(NSRangeException) {controller.view.attachment_point_view.removeObserver(controller.view, forKeyPath: 'not_center') }
    end

    it 'creates an observer for DecorationView\'s attached_view object\'s centre method' do
      should.not.raise(NSRangeException) {controller.view.attached_view.removeObserver(controller.view, forKeyPath: 'center') }
      should.raise(NSRangeException) {controller.view.attached_view.removeObserver(controller.view, forKeyPath: 'not_center') }
    end
  end

  describe 'AttachmentsView UIPanGestureRecognizer action method #handle_attachment_gesture.' do

    it 'should set the attachment_behavior\'s anchorPoint.' do
      (controller.attachment_behavior.anchorPoint.x == 0.0 && controller.attachment_behavior.anchorPoint.y == 0.0).should.equal false
      gesture = controller.view.gestureRecognizers[0]
      controller.send(:handle_attachment_gesture, gesture)
      (controller.attachment_behavior.anchorPoint.x == 0.0 && controller.attachment_behavior.anchorPoint.y == 0.0).should.equal true
    end

    it 'should set the attachment_view\'s center to be equal to the anchorPoint center.' do
      (controller.attachment_view.center.x == controller.attachment_behavior.anchorPoint.x).should.equal true
      (controller.attachment_view.center.y == controller.attachment_behavior.anchorPoint.y).should.equal true
    end
  end
end
