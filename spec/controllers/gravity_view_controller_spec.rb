describe GravityViewController do

  tests GravityViewController

  after do
    SpecHelper.create_help_methods.window_cleanup(window, controller)
  end

  describe 'GravityViewController #viewDidLoad' do
    it 'created an ImageView subview: box' do
      controller.box.class.should.equal UIImageView
    end
  end

  describe 'GravityViewController #viewDidAppear' do
    it 'adds a behaviour to the animator' do
      controller.animator.behaviors.count.should.equal 1
    end
    it 'the behaviour is a UIGravityBehavior behaviour' do
      controller.animator.behaviors[0].class.should.equal UIGravityBehavior
    end
  end
end
