describe BaseViewController do

  tests BaseViewController

  describe 'BaseViewController #new_box' do

    it 'should create  attr_accessor :box' do
      SpecHelper.create_help_methods.do_methods_respond(controller, :box, :box=).should.equal 'All Methods responded'
    end

    it 'creates a background colour pattern using the image background_tile.png))' do
      UIColor.colorWithPatternImage(UIImage.imageNamed('background_tile.png')).should.equal controller.view.backgroundColor
    end

    it 'returns a UIImageView box' do
      controller.new_box(0, 0).should.be.kind_of UIImageView
    end
  end

  describe 'BaseViewController #animator' do
    it 'returns an animator' do
      controller.animator.should.be.kind_of UIDynamicAnimator
    end
  end
end
