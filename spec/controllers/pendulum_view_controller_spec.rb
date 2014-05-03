describe PendulumViewController do
  before do
    @help_methods = SpecHelper.create_help_methods
  end

  tests PendulumViewController

  describe '#init' do

    it 'should create three attr_accessors :attachmentPoint, :pendulumBehavior, :animator' do
      @help_methods.do_methods_respond(controller, :attachmentPoint, :attachmentPoint=, :pendulumBehavior, :pendulumBehavior=,
                                   :animator, :animator=).
                                   should.equal 'All Methods responded'
    end

  end

  describe '#viewDidLoad' do

    it 'should assign attachmentPoint imageImageView to the first subview of the controller\'s view. ' do
      controller.view.subviews[0].class.should.equal UIImageView
    end

    it 'should assign box imageImageView to the second subview of the controller\'s view. ' do
      controller.view.subviews[1].object_id.should.equal controller.box.object_id
    end

  end


end