describe CollisionViewController do

  tests CollisionViewController

  after do
    SpecHelper.create_help_methods.window_cleanup(window, controller)
  end

  describe "#viewDidLoad" do
    it "adds a box to the subview" do
      controller.view.subviews.count.should.equal 1
    end
  end

  describe "#viewDidAppear" do

    it "add two behaviors" do
      controller.animator.behaviors.count.should.equal 2
    end
  end
end
