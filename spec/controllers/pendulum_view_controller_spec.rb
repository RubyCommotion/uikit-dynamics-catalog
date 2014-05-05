describe PendulumViewController do
  before do
    @help_methods = SpecHelper.create_help_methods
  end

  tests PendulumViewController

  describe '#init' do
    it 'should create attr_accessors :attachmentPoint, :pendulumBehavior' do
      @help_methods.do_methods_respond(controller, :attachmentPoint, :attachmentPoint=, :pendulumBehavior, :pendulumBehavior=).
                                   should.equal 'All Methods responded'
    end
  end

  describe '#viewDidLoad' do
    # subview tags are self.view 0, label 1, box 2 and attachmentPoint 3
    it 'should assign a UILabel as a controller Subview. ' do
      controller.view.subviews[1].class.should.equal UILabel
      controller.view.subviews[1].object_id.should.equal controller.instance_variable_get('@label').object_id
    end

    it 'should assign box imageImageView to the second subview of the controller\'s view. ' do
      controller.view.subviews[2].class.should.equal NSKVONotifying_UIImageView
      controller.view.subviews[2].object_id.should.equal controller.box.object_id
    end

    it 'should assign attachmentPoint imageImageView as a controller Subview.' do
      controller.view.subviews[3].class.should.equal NSKVONotifying_UIImageView
      controller.view.subviews[3].object_id.should.equal controller.attachmentPoint.object_id
    end

    # self.view.trackAndDrawAttachmentFromView tested via decoration_view_spec.rb
  end

end