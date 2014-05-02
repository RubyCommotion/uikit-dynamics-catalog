describe DecorationView do

  before do
    @view = DecorationView.alloc.init
    @help_methods = SpecHelper.create_help_methods
  end

  describe '#init' do

    it 'should create a UIView object' do
      @view.superclass.should.equal UIView
    end

    it 'should create seven attr_accessors :attachment_point_view, :attached_view, :attachment_offset, :attachment_decoration_layers, :center_point_view, arrow_view' do
      @help_methods.do_methods_respond(@view, :attachment_point_view, :attachment_point_view=, :attached_view, :attached_view=,
                                   :attachment_offset, :attachment_offset=,
                                   :attachment_decoration_layers, :attachment_decoration_layers=,
                                   :arrow_view, :arrow_view=,
                                   :center_point_view, :center_point_view= ).
                                   should.equal 'All Methods responded'
    end


    it 'should create an arrow_view attr_accessor initialized with an UIImageView' do
      @view.instance_variable_get('@arrow_view').class.should.equal UIImageView
    end

    it 'should create an attachment_decoration_layers array of four UIImageViews' do
      @view.instance_variable_get('@attachment_decoration_layers').class.should.equal Array
      @view.instance_variable_get('@attachment_decoration_layers').size.should.equal 4
    end
  end

  # dealloc method is tested by the attachments_view_controller_spec.rb test file

  describe '#drawMagnitudeVectorWithLength with param forLimitedTime == false' do
    before do
      @obj = @view.drawMagnitudeVectorWithLength(100.0, angle: 0.0, color: UIColor.redColor, forLimitedTime: false)
    end
    it 'should return a UIVImageView with tintColor red and alpha of 1' do
      @obj.class.should.equal UIImageView
      @obj.tintColor.should.equal UIColor.redColor
      @obj.alpha.should.equal 1.0
    end
  end

  describe '#drawMagnitudeVectorWithLength with param forLimitedTime == true' do
    before do
      @obj = @view.drawMagnitudeVectorWithLength(100.0, angle: 0.0, color: UIColor.redColor, forLimitedTime: true)
    end
    it 'should return a UIVImageView with an alpha of 0.0' do
      wait 1.5 do
        @obj.alpha.should.equal 0.0
      end
    end
  end

  describe '#drawMagnitudeVectorWithLength does a transform rotate' do
    it 'It should do a transform rotate of the arrow_view ' do
      should.not.raise(ArgumentError) {@view.drawMagnitudeVectorWithLength(100.0, angle: 1.0, color: UIColor.redColor, forLimitedTime: true)}
      should.raise(ArgumentError) {@view.drawMagnitudeVectorWithLength(100.0, angle: 'rotate', color: UIColor.redColor, forLimitedTime: true)}
    end
  end

  describe '#trackAndDrawAttachmentFromView' do
    it 'observers created by this method are tested under attachments_view_controller_spec.rb' do
      true.should == true
    end
  end

  describe '#layoutSubviews' do
    before do
      @view.layoutSubviews
      @attachment_view_controller = AttachmentsView.alloc.init
      @attachment_view_controller.view.trackAndDrawAttachmentFromView(@attachment_view_controller.attachment_view,
                                                                      toView: @attachment_view_controller.square1,
                                                                      withAttachmentOffset: CGPointMake(-25.0, -25.0))

      @attachment_points =  @attachment_view_controller.view.send(:create_attachment_points)
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(@view)
      @required_dashes = @view.send(:number_of_required_dashes, @calc_distance_and_angle[:distance])
    end

    it 'should assign UIView\'s center point to arrow_view ImageView' do
      @view.arrow_view.center.x.should.equal CGRectGetMidX(@view.bounds)
      @view.arrow_view.center.y.should.equal CGRectGetMidY(@view.bounds)
    end

    it 'should invoke #make_transform_object and transform the attachment_point_view via a TRANSLATION transform' do
      should.not.raise(ArgumentError) {@view.send(:make_transform_object, @attachment_points[:attachment_point_view_center], @calc_distance_and_angle[:angle])}
      @attachment_points_that_fail = @help_methods.create_object_with_method_x # an object with x and y mewthods that return a string
      # an ArgumentError when try to give CGAffineTransformMakeTranslation a string argument
      should.raise(ArgumentError) {@view.send(:make_transform_object, @attachment_points_that_fail, @calc_distance_and_angle[:angle])}
    end

    it 'should invoke #make_transform_object and transform the attachment_point_view via a ROTATION transform' do
      should.not.raise(ArgumentError) {@view.send(:make_transform_object, @attachment_points[:attachment_point_view_center], @calc_distance_and_angle[:angle])}
      @attachment_points =  @attachment_view_controller.view.send(:create_attachment_points)
      # NoMethodError when try to substract a float from a string in case of a CGAffineTransformRotate
      should.raise(NoMethodError) {@view.send(:make_transform_object, @attachment_points[:attachment_point_view_center], 'not an angle')}
    end

    it 'should invoke #do_transform and do a translational transform of the dashes' do
      transform_object = @view.send(:make_transform_object, @attachment_points[:attachment_point_view_center], @calc_distance_and_angle[:angle])
      dash_spacing = @view.send(:dash_spacing, @calc_distance_and_angle[:distance], @required_dashes[:d], @required_dashes[:required_dashes])
      should.not.raise(ArgumentError) {@view.send(:do_transform, @required_dashes[:required_dashes], @required_dashes[:dash_layer], dash_spacing, transform_object)}
      # expects instance of `CGAffineTransform', will get `nil'
      should.raise(TypeError) {@view.send(:do_transform, @required_dashes[:required_dashes], @required_dashes[:dash_layer], dash_spacing, nil)}
    end

  end

  describe '#create_attachment_points' do

    before do
      @attachment_view_controller = AttachmentsView.alloc.init
      @attachment_view_controller.view.trackAndDrawAttachmentFromView(@attachment_view_controller.attachment_view,
                                                                      toView: @attachment_view_controller.square1,
                                                                      withAttachmentOffset: CGPointMake(-25.0, -25.0))
      @attachment_point_view_center =  @attachment_view_controller.view.send(:create_attachment_points)
    end

    it 'should create a Hash containing attachment_point_view_center and attached_view_attachment_point both of which should be of class type GCPoint' do
      @attachment_point_view_center.class.should.equal Hash
      @attachment_point_view_center[:attachment_point_view_center].class.should.equal CGPoint
      @attachment_point_view_center[:attached_view_attachment_point].class.should.equal CGPoint
    end
  end

  describe '#calc_distance_and_angle' do
    before do
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(@view)
    end

    it 'should create a Hash that contains distance and angle values of class type Float' do
      @calc_distance_and_angle.class.should.equal Hash
    end

    it 'for an offset of -25.0, -25.0 it should calculate a distance of approximately 88 points.' do
      @calc_distance_and_angle[:distance].to_i.should.equal 88
    end

    it 'for an offset of -25.0, -25.0 it should calculate an angle of approximately 1.8 radians.' do
      @calc_distance_and_angle[:angle].round(2).should.equal 1.861.round(2)
    end
  end


  describe '#number_of_required_dashes' do
    before do
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(@view)
      @required_dashes = @view.send(:number_of_required_dashes, @calc_distance_and_angle[:distance])
    end

    it 'should set the required number of dashes between the square and the attchment view to 4.' do
      @required_dashes[:required_dashes].should.equal 4
    end
  end

  describe '#dash_spacing' do
    before do
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(@view)
      @required_dashes = @view.send(:number_of_required_dashes, @calc_distance_and_angle[:distance])
    end
    it 'should set the spacing between dashes.' do
      @view.send(:dash_spacing, @calc_distance_and_angle[:distance], @required_dashes[:d], @required_dashes[:required_dashes]).class.should.equal Float
    end
  end

  describe '#hidden_dashes' do
    before do
      @view.send(:hide_dashes, 2, 4)
    end
    it 'for required dashes = 2 and max dashes = 4 should hide  elements 2 and 3 of the attachment_decoration_layers array (representing attachment dashes).' do
      @view.attachment_decoration_layers[0].hidden.should.equal false
      @view.attachment_decoration_layers[1].hidden.should.equal false
      @view.attachment_decoration_layers[2].hidden.should.equal true
      @view.attachment_decoration_layers[3].hidden.should.equal true
    end

  end

end