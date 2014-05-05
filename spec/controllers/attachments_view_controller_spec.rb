describe AttachmentsView do

  before do
    @help_methods = SpecHelper.create_help_methods
  end

  tests AttachmentsView

  after do
    SpecHelper.create_help_methods.window_cleanup(window, controller)
  end

  describe '#init' do

    it 'should create seven attr_accessors :attachment_behavior, :square1, :box1, :sq1_attachment_image_view, :attachment_view ' do
      @help_methods.do_methods_respond(controller, :collision_behavior, :collision_behavior=,
                                   :attachment_behavior, :attachment_behavior=, :square1, :square1=,
                                   :box1, :box1=, :sq1_attachment_image_view, :sq1_attachment_image_view=, :attachment_view, :attachment_view=).
                                   should.equal 'All Methods responded'
    end
  end


  describe '#loadView' do
    it 'creates a DecorationView root view' do
      controller.view.class.should.equal DecorationView
    end
  end

  describe '#viewDidLoad' do

   it 'added four subviews' do
      controller.self.view.subviews.count.should.equal 4
    end

    it 'created an ImageView subview: square1' do
      controller.sq1_attachment_image_view.class.should.equal UIImageView
    end

    it 'added two subviews to the square1 ImageView ' do
      controller.square1.subviews.count.should.equal 2
    end

    it 'created an ImageView subview: @box1' do
      controller.box1.class.should.equal UIImageView
    end

    it 'created a UILabel subview' do
      # use to send to access private method
      controller.send(:create_instructions_label).class.should.equal UILabel
    end

    it 'added a panGestureRecognizer for the root view' do
      controller.self.view.gestureRecognizers.count.should.equal 1
    end

    it 'added two behaviors' do
      controller.animator.behaviors.count.should.equal 2
    end

    it 'added a collision behaviour with mode UICollisionBehaviorModeEverything' do
      controller.collision_behavior.collisionMode.should.equal(-1)
    end

    it 'added an attachment behaviour with one item' do
      controller.attachment_behavior.items.count.should.equal 1
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
end
