describe CollisionViewController do

  tests CollisionViewController

  describe "CollisionViewController #viewDidLoad" do
    it 'adds a box subview to the controller view' do
      controller.view.subviews.count.should.equal 1
      controller.view.subviews[0].class.should.equal UIImageView
      controller.view.subviews[0].accessibilityLabel.should.equal 'Box'
    end
  end

  describe "CollisionViewController #viewDidAppear" do

    it "adds two behaviors" do
      controller.animator.behaviors.count.should.equal 2
    end

    it 'adds a UIGravityBehavior behaviour' do
      controller.animator.behaviors[0].class.should.equal UIGravityBehavior
    end

    it 'adds a UICollisionBehavior behaviour' do
      controller.animator.behaviors[1].class.should.equal UICollisionBehavior
    end

  end
end
