describe ContinuousPushViewController do

  tests ContinuousPushViewController

  describe "\n#ContinuousPushViewController" do

    it 'should create a square1 attr_accessor' do
      controller.respond_to?(:square1).should == true
      controller.respond_to?(:square1=).should == true
    end

    it 'should create a animator attr_accessor' do
      controller.respond_to?(:animator).should == true
      controller.respond_to?(:animator=).should == true
    end

    it 'should create a push_behavior attr_accessor' do
      controller.respond_to?(:push_behavior).should == true
      controller.respond_to?(:push_behavior=).should == true
    end
  end


  describe "\n#loadView" do
    it 'should create a DecorationView root view' do
    controller.view.class.should == DecorationView
    end
  end


  describe "\n#viewDidLoad" do

    it 'should create one root view gesture recognizer' do
    controller.view.gestureRecognizers.count.should == 1
    end

    it 'should create a tap gesture recognizer' do
    controller.view.gestureRecognizers[0].class.should == UITapGestureRecognizer
    end

    it 'should have a root view with subviews' do
    controller.view.subviews.count.should > 0
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


  describe "\n#viewDidAppear" do

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

end