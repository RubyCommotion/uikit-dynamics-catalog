describe BaseViewController do

  after do
    SpecHelper.create_help_methods.window_cleanup(window, controller)
  end

  tests BaseViewController

  describe 'BaseViewController #new_box' do
    it 'returns an image view' do
      controller.new_box(0, 0).should.be.kind_of UIImageView
    end
  end

  describe 'BaseViewController #animator' do
    it 'returns an animator' do
      controller.animator.should.be.kind_of UIDynamicAnimator
    end
  end
end
