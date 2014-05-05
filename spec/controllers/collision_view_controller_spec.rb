describe CollisionViewController do
  # before do
  #   @subject = CollisionViewController.new
  # end

  tests CollisionViewController

  describe "#viewDidLoad" do
    it "adds a box to the subview" do
      controller.view.subviews.count.should.equal 1
    end
  end

  describe "#viewDidAppear" do
    # before do
    #   controller.viewDidLoad
    #   controller.viewDidAppear(false)
    # end

    it "add two behaviors" do
      controller.animator.behaviors.count.should.equal 2
    end
  end
end
