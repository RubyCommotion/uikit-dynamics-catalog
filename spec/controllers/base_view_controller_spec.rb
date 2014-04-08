describe BaseViewController do

  tests BaseViewController

  describe '#new_box' do
    it 'returns an image view' do
      controller.new_box(0, 0).should.be.kind_of UIImageView
    end
  end

  describe '#animator' do
    it 'returns an animator' do
      controller.animator.should.be.kind_of UIDynamicAnimator
    end
  end
end
