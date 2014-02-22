describe GravityViewController do
  before do
    @subject = GravityViewController.new
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

    it "adds the behavior to the animator" do
      @subject.animator.behaviors.count.should.equal 1
    end
  end
end
