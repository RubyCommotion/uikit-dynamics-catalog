describe CollisionViewController do

  tests CollisionViewController

  describe "CollisionViewController #viewDidLoad" do
    it "adds a box to the subview" do
      controller.view.subviews.count.should.equal 1
    end
  end

  describe "CollisionViewController #viewDidAppear" do

    it "add two behaviors" do
      controller.animator.behaviors.count.should.equal 2
    end
  end
end
