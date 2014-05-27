view_controllers = [ContinuousPushViewController, InstantaneousPushViewController]

view_controllers.each  do |view_controller|

  describe "\nTests controller: ===>> #{view_controller.to_s} <<===" do
    @controller_name = view_controller.to_s

    if view_controller ==  ContinuousPushViewController
      @controller = ContinuousPushViewController.alloc.init(DecorationView.alloc.init)
    else
      @controller = InstantaneousPushViewController.alloc.init(DecorationView.alloc.init)
    end

    tests view_controller

    def controller
      @controller
    end

    describe "#{@controller_name}\'s init" do
      it 'should create a square1 and push_behavior attr_accessors.' do
        SpecHelper.create_help_methods.do_methods_respond(controller, :square1, :square1=, :push_behavior, :push_behavior=).should.equal 'All Methods responded'
      end
    end

    describe "#{@controller_name} #loadView" do
      it 'should create a controller view of class type DecorationView' do
        controller.view.class.should == DecorationView
      end
    end

    describe "#{@controller_name}  #viewDidLoad" do

      it 'should create controller view gesture recognizer' do
        controller.view.gestureRecognizers.count.should.equal 1
      end

      it 'should create a tap gesture recognizer' do
        controller.view.gestureRecognizers[0].class.should == UITapGestureRecognizer
      end

      it 'should have created six subviews of controller view' do
        controller.view.subviews.count.should.equal 6
      end

      it 'should create a Square UIView view' do
        controller.view.subviews[1].accessibilityLabel.should.equal 'Square'
        controller.view.subviews[1].class.should.equal UIView
      end

      it 'should create a box UIImageView view as a subview of Square' do
        square_view = controller.view.subviews[1]
        square_view.subviews.count.should.equal 1
        square_view.subviews[0].accessibilityLabel.should.equal 'Box'
        square_view.subviews[0].class.should.equal UIImageView

      end

      it 'should create an origin UIImageView view' do
        controller.view.subviews[2].accessibilityLabel.should.equal 'Origin'
        controller.view.subviews[2].class.should.equal UIImageView
      end

      it 'should create an UILabel view' do
        controller.view.subviews[3].accessibilityLabel.should.equal 'Tap anywhere to create a force'
        controller.view.subviews[3].class.should.equal UILabel
      end
    end


    describe "#{@controller_name} #viewDidAppear" do
      it 'should create an animator' do
        controller.animator.class.should == UIDynamicAnimator
      end

      it 'should create a collision behaviour' do
        controller.animator.behaviors[0].class.should == UICollisionBehavior
      end

      it 'should create a push behaviour' do
        controller.animator.behaviors[1].class.should == UIPushBehavior
      end

      it 'should set the initial value of the push angle and distance to 0.0' do
        controller.push_behavior.angle.should == 0.0
        controller.push_behavior.magnitude.should == 0.0
      end
    end

    describe "#{@controller_name}'s gesture recognizer's action" do

      it 'should change the initial value of the acting push angle and distance after tapping box view' do
        tap('Box', at: :top_left, :times => 1, :touches => 1)
        controller.push_behavior.angle.should.not == 0.0
        controller.push_behavior.magnitude.should.not == 0.0
      end
    end
  end
end