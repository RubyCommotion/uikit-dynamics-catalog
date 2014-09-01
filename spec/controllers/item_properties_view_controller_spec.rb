describe ItemPropertiesViewController do

  before do
    @help_methods = SpecHelper.create_help_methods
  end

  tests ItemPropertiesViewController

  describe 'ItemPropertiesViewController #init' do

    it 'should create the ivars @box_one and @box_two' do
      SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@box_one'), :ivar_class => UIImageView},
                                          {:ivar_instance => controller.instance_variable_get('@box_two'), :ivar_class => UIImageView}])
    end

    it 'should create attr_accessors :box_one_property and :box_two_property' do
    @help_methods.do_methods_respond(controller, :box_one_property, :box_one_property=, :box_two_property, :box_two_property=).
                                 should.equal 'All Methods responded'


    end
  end

  describe 'ItemPropertiesViewController #viewDidLoad' do

    it 'should assign box_one imageImageView to the first subview of the controller\'s view.' do
      controller.view.subviews[0].object_id.should.equal controller.instance_variable_get('@box_one').object_id
    end

    it 'should assign box_two imageImageView to the second subview of the controller\'s view.' do
      controller.view.subviews[1].object_id.should.equal controller.instance_variable_get('@box_two').object_id
    end

    it 'should create a UIBarButtonItem titled \'Restart\'' do
      controller.navigationItem.rightBarButtonItem.class.should.equal UIBarButtonItem
      button = controller.send(:new_replay_button)
      button.title.should.equal 'Restart'
      button.action.should.equal :replay_action
      button.target.should.equal controller.self
    end

    it 'should create a box_one imageImageView.' do
      controller.viewDidLoad #viewDidLoad invoked as ViewDidAppear had modified box_one
      @help_methods.test_image_view('box1', controller.instance_variable_get('@box_one'), 40.0, 100.0).should.equal true
    end

    it 'should have created a box_two imageImageView.' do
      controller.viewDidLoad #viewDidLoad invoked as ViewDidAppear had modified box_two
      @help_methods.test_image_view('box2', controller.instance_variable_get('@box_two'), 180.0, 100.0).should.equal true
    end


  end

  describe 'ItemPropertiesViewController #viewDidAppear' do
    it 'should add four behaviours to the animator.' do
      controller.animator.behaviors.size.should.equal 4
    end
  end

  describe "ItemPropertiesViewController #replay_action" do
    it 'should reset the box1 and box 2 UIImageViews\' x origin coordinates to be at the top of the view' do
      controller.send(:replay_action)
      controller.instance_variable_get('@box_one').center.x.should.equal 90
      controller.instance_variable_get('@box_two').center.x.should.equal 230
    end
  end

  # TODO looks like a redundant test that's not needed.
  describe "ItemPropertiesViewController #replay_action" do
    it 'should fail to run returning a NoMethodError for method addLinearVelocity when box_one_property or box_two_property set to a string object.' do
      tmp_box_one_property = controller.box_one_property
      controller.box_one_property = 'string not a UIDynamicItemBehavior'
      should.raise(NoMethodError){controller.send(:replay_action)}
      controller.box_one_property = tmp_box_one_property
      controller.box_two_property = 'string not a UIDynamicItemBehavior'
      should.raise(NoMethodError){controller.send(:replay_action)}
    end
  end
end
