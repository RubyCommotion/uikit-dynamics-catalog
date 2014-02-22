describe CollisionViewController do
  before do
    @subject = CollisionViewController.new
  end

  describe "#viewDidLoad" do
    it "adds a box to the subview" do
      @subject.view.subviews.count.should.equal 1
    end
  end

  describe "#viewDidAppear" do
    before do
      @subject.viewDidLoad
      @subject.viewDidAppear(false)
    end

    it "add two behaviors" do
      @subject.animator.behaviors.count.should.equal 2
    end
  end
end
