describe DecorationView do

  before do
    @view = DecorationView.alloc.init
  end

  # tests DecorationView

  describe '#init' do

    it 'should create a view object' do
      @view.superclass.should.equal UIView
    end

    it 'should create an arrow UIImageView' do
      @view.instance_variable_get('@arrow_view').class.should.equal UIImageView
    end

    it 'should create an attachment array of UIImageViews' do
      @view.instance_variable_get('@attachment_decoration_layers').class.should.equal Array
    end
  end

    describe '#drawMagnitudeVectorWithLength' do
      before do
        @obj = @view.drawMagnitudeVectorWithLength(100.0, angle: 0.0, color: UIColor.redColor, forLimitedTime: false)
      end
      it 'should return a UIVImageView' do
        @obj.class.should.equal UIImageView
      end

  end

end


