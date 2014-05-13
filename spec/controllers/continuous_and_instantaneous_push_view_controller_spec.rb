vcs = [ContinuousPushViewController, InstantaneousPushViewController]

vcs.each do |vc|
  describe "\nTest: ===#{vc} ===" do

    before do
      @help_methods = SpecHelper.create_help_methods
    end


    tests vc

    after do
      @help_methods.window_cleanup(window, controller)
    end

    describe "#{vc.to_s}\'s init" do

      it 'should create a square1 and push_behavior attr_accessors' do
        @help_methods.do_methods_respond(controller, :square1, :square1=, :push_behavior, :push_behavior=).should.equal 'All Methods responded'
      end
    end

    describe "#{vc} #loadView" do
      it 'should create a DecorationView root view' do
        controller.view.class.should == DecorationView
      end
    end

    describe "#{vc}  #viewDidLoad" do

      it 'should create root view gesture recognizer(s)' do
        controller.view.gestureRecognizers.count.should != 0
      end

      if vc == InstantaneousPushViewController
        it 'should create a pan gesture recognizer' do
          controller.view.gestureRecognizers[0].class.should == UIPanGestureRecognizer
        end

        it 'should create a tap gesture recognizer' do
          controller.view.gestureRecognizers[1].class.should == UITapGestureRecognizer
        end
      else
        it 'should create a tap gesture recognizer' do
          controller.view.gestureRecognizers[0].class.should == UITapGestureRecognizer
        end
      end

      it 'should have created subviews of root view' do
        controller.view.subviews.count.should.be > 0
      end

      it 'should create a square view' do
        view('Square contains a box').class.should == UIView
      end

      it 'should create a box view' do
        view('Is a box').class.should == UIImageView
      end

      it 'should create an origin view' do
        view('Is an origin').class.should == UIImageView
      end

      it 'should create an label view' do
        view('Tap anywhere to create a force').class.should == UILabel
      end
    end


    describe "#{vc} #viewDidAppear" do

      it 'should create an animator' do
        controller.animator.class.should == UIDynamicAnimator
      end

      it 'should create an animator with a collision behaviour' do
        controller.animator.behaviors[0].class.should == UICollisionBehavior
      end

      it 'should create an animator with a push behaviour' do
        controller.animator.behaviors[1].class.should == UIPushBehavior
      end
    end


    if vc == ContinuousPushViewController
      class_name = ContinuousPushViewController.to_s
    else
      class_name = InstantaneousPushViewController.to_s
    end

    describe "#{class_name}'s #viewDidAppear" do

      it 'should set the initial value of the push angle and distance to 0.0' do
        controller.push_behavior.angle.should == 0.0
        controller.push_behavior.magnitude.should == 0.0
      end
    end

    describe "#{class_name}'s gesture recognizer" do
      before do
        tap('Is a box', at: :top_left, :times => 1, :touches => 1)
      end
      it 'should change the initial value of the push angle and distance after tapping box view' do
        controller.push_behavior.angle.should.not == 0.0
        controller.push_behavior.magnitude.should.not == 0.0
      end
    end
  end
end