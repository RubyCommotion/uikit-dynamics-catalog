describe BaseViewController do
  before do
    @subject = BaseViewController.new
  end

  describe "#new_box" do
    it "returns an image view" do
      @subject.new_box(0, 0).should.be.kind_of UIImageView
    end
  end

  describe "#animator" do
    it "returns an animator" do
      @subject.animator.should.be.kind_of UIDynamicAnimator
    end
  end
end
