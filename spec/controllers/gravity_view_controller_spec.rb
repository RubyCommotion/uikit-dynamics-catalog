describe GravityViewController do

  tests GravityViewController

  describe 'GravityViewController #viewDidLoad' do
    it 'created an ImageView controller subview: box' do
      controller.view.subviews[0].accessibilityLabel.should.equal 'Box'
      view('Box').class.should.equal UIImageView
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
