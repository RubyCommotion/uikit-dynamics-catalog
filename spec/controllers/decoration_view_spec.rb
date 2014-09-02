describe DecorationView do

  before do
    @help_methods = SpecHelper.create_help_methods
  end

  def controller
    @controller ||= DecorationView.alloc.init
  end

  describe 'DecorationView #init' do

    it 'should create a UIView object' do
      controller.superclass.should.equal UIView
    end

    it 'should create an arrow_view ivar initialized  as a UIImageView' do
      controller.instance_variable_get('@arrow_view').class.should.equal UIImageView
    end

    it 'should create an attachment_decoration_layers array of four UIImageViews' do
      controller.instance_variable_get('@attachment_decoration_layers').class.should.equal Array
      controller.instance_variable_get('@attachment_decoration_layers').size.should.equal 4
    end

    it 'should create attr_accessors :attachment_point_view and :attached_view' do
      @help_methods.do_methods_respond(controller, :attachment_point_view, :attachment_point_view=, :attached_view, :attached_view=).
                                   should.equal 'All Methods responded'
    end
  end

  # dealloc method is tested by the attachments_view_controller_spec.rb test file


  describe 'DecorationView method #drawMagnitudeVectorWithLength with param forLimitedTime == false' do
    before do
      @obj = controller.drawMagnitudeVectorWithLength(100.0, angle: 0.0, color: UIColor.redColor, forLimitedTime: false)
    end
    it 'should return a UIVImageView with tintColor red and alpha of 1' do
      @obj.class.should.equal UIImageView
      @obj.tintColor.should.equal UIColor.redColor
      @obj.alpha.should.equal 1.0
    end
  end


  describe 'DecorationView #drawMagnitudeVectorWithLength with param forLimitedTime == true' do
    before do
      @obj = controller.drawMagnitudeVectorWithLength(100.0, angle: 0.0, color: UIColor.redColor, forLimitedTime: true)
    end
    it 'should return a UIVImageView with an alpha of 0.0' do
      wait 1.5 do
        @obj.alpha.should.equal 0.0
      end
    end
  end


  describe 'DecorationView #drawMagnitudeVectorWithLength does a transform rotate' do
    it 'It should do a transform rotate of the arrow_view ' do
      should.not.raise(ArgumentError) {controller.drawMagnitudeVectorWithLength(100.0, angle: 1.0, color: UIColor.redColor, forLimitedTime: true)}
      # test presence of transform by setting angle to a string vs the required real value.
      should.raise(ArgumentError) {controller.drawMagnitudeVectorWithLength(100.0, angle: 'rotate', color: UIColor.redColor, forLimitedTime: true)}
    end
  end


  describe 'DecorationView  #trackAndDrawAttachmentFromView' do
    # observers created by this method are tested under attachments_view_controller_spec.rb

    it 'should create three ivars @attachment_point_view, @attached_view and @attachment_offset' do
      @attachment_view_controller = AttachmentsView.alloc.init(controller)
      @attachment_view_controller.view.trackAndDrawAttachmentFromView(@attachment_view_controller.instance_variable_get('@attachment_view'),
                                                                      toView: @attachment_view_controller.instance_variable_get('@square1'),
                                                                      withAttachmentOffset: CGPointMake(-25.0, -25.0))


       SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@attachment_point_view'), :ivar_class => NSKVONotifying_UIImageView},
                                          {:ivar_instance => controller.instance_variable_get('@attached_view'), :ivar_class =>  NSKVONotifying_UIView},
                                          {:ivar_instance => controller.instance_variable_get('@attachment_offset'), :ivar_class =>  CGPoint}
                                        ])
    end
  end


  describe 'DecorationView #layoutSubviews' do
    before do
      controller.layoutSubviews
      @attachment_view_controller = AttachmentsView.alloc.init(DecorationView.alloc.init)
      @attachment_view_controller.view.trackAndDrawAttachmentFromView(@attachment_view_controller.instance_variable_get('@attachment_view'),
                                                                      toView: @attachment_view_controller.instance_variable_get('@square1'),
                                                                      withAttachmentOffset: CGPointMake(-25.0, -25.0))

      @attachment_points =  @attachment_view_controller.view.send(:create_attachment_points)
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(controller)
      @required_dashes = controller.send(:number_of_required_dashes, @calc_distance_and_angle[:distance])
    end

    it 'should assign UIView\'s center point to arrow_view ImageView' do
      controller.instance_variable_get('@arrow_view').center.x.should.equal CGRectGetMidX(controller.bounds)
      controller.instance_variable_get('@arrow_view').center.y.should.equal CGRectGetMidY(controller.bounds)
    end

    it 'should invoke #make_transform_object and transform the attachment_point_view via a TRANSLATION transform' do
      should.not.raise(ArgumentError) {controller.send(:make_transform_object, @attachment_points[:attachment_point_view_center], @calc_distance_and_angle[:angle])}
      @attachment_points_that_fail = @help_methods.create_object_with_method_x # an object with x and y mewthods that return a string
      # an ArgumentError when try to give CGAffineTransformMakeTranslation a string argument
      should.raise(ArgumentError) {controller.send(:make_transform_object, @attachment_points_that_fail, @calc_distance_and_angle[:angle])}
    end

    it 'should invoke #make_transform_object and transform the attachment_point_view via a ROTATION transform' do
      should.not.raise(ArgumentError) {controller.send(:make_transform_object, @attachment_points[:attachment_point_view_center], @calc_distance_and_angle[:angle])}
      @attachment_points =  @attachment_view_controller.view.send(:create_attachment_points)
      # NoMethodError when try to substract a float from a string in case of a CGAffineTransformRotate
      should.raise(NoMethodError) {controller.send(:make_transform_object, @attachment_points[:attachment_point_view_center], 'not an angle')}
    end

    it 'should invoke #do_transform and do a translational transform of the dashes' do
      transform_object = controller.send(:make_transform_object, @attachment_points[:attachment_point_view_center], @calc_distance_and_angle[:angle])
      dash_spacing = controller.send(:dash_spacing, @calc_distance_and_angle[:distance], @required_dashes[:d], @required_dashes[:required_dashes])
      should.not.raise(ArgumentError) {controller.send(:do_transform, @required_dashes[:required_dashes], @required_dashes[:dash_layer], dash_spacing, transform_object)}
      # expects instance of `CGAffineTransform', will get `nil'
      should.raise(TypeError) {controller.send(:do_transform, @required_dashes[:required_dashes], @required_dashes[:dash_layer], dash_spacing, nil)}
    end
  end

    describe 'DecorationView #create_attachment_points' do

    @attachment_view_controller = AttachmentsView.alloc.init(DecorationView.alloc.init)

    @attachment_view_controller.view.trackAndDrawAttachmentFromView(@attachment_view_controller.instance_variable_get('@attachment_view'),
                                                                    toView: @attachment_view_controller.instance_variable_get('@square1'),
                                                                    withAttachmentOffset: CGPointMake(-25.0, -25.0))


    @attachment_point_view_center =  @attachment_view_controller.view.send(:create_attachment_points)

    it 'should create a Hash containing attachment_point_view_center and attached_view_attachment_point both of which should be of class type GCPoint' do
      @attachment_point_view_center.class.should.equal Hash
      @attachment_point_view_center[:attachment_point_view_center].class.should.equal CGPoint
      @attachment_point_view_center[:attached_view_attachment_point].class.should.equal CGPoint
    end
  end

  describe 'DecorationView #calc_distance_and_angle' do
    before do
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(controller)
    end

    it 'should create a Hash that contains distance and angle values of class type Float' do
      @calc_distance_and_angle.class.should.equal Hash
    end

    it 'should,for an offset of -25.0, -25.0, calculate a distance of approximately 88 points.' do
      @calc_distance_and_angle[:distance].to_i.should.equal 88
    end

    it 'should, for an offset of -25.0, -25.0, calculate an angle of approximately 1.8 radians.' do
      @calc_distance_and_angle[:angle].round(2).should.equal 1.861.round(2)
    end
  end


  describe 'DecorationView #number_of_required_dashes' do
    before do
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(controller)
      @required_dashes = controller.send(:number_of_required_dashes, @calc_distance_and_angle[:distance])
    end

    it 'should set the required number of dashes between the square and the attchment view to 4.' do
      @required_dashes[:required_dashes].should.equal 4
    end
  end

  describe 'DecorationView #dash_spacing' do
    before do
      @calc_distance_and_angle = @help_methods.calc_distance_and_angle(controller)
      @required_dashes = controller.send(:number_of_required_dashes, @calc_distance_and_angle[:distance])
    end
    it 'should set the spacing between dashes.' do
      controller.send(:dash_spacing, @calc_distance_and_angle[:distance], @required_dashes[:d], @required_dashes[:required_dashes]).class.should.equal Float
    end
  end

  describe 'DecorationView #hidden_dashes' do
    before do
      controller.send(:hide_dashes, 2, 4)
    end
    it 'should hide  elements 2 and 3 of the attachment_decoration_layers array (representing attachment dashes) for required dashes = 2 and max dashes = 4.' do
      adl = controller.instance_variable_get('@attachment_decoration_layers')
      adl[0].hidden.should.equal false
      adl[1].hidden.should.equal false
      adl[2].hidden.should.equal true
      adl[3].hidden.should.equal true
    end
  end
end

