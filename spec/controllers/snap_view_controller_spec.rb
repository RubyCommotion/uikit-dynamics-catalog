describe SnapViewController do

   tests SnapViewController

  describe 'SnapViewController #viewDidLoad' do
    it 'should assign a UILabel as the first controller subview.' do
      controller.view.subviews[0].object_id.should.equal controller.instance_variable_get('@label').object_id
    end

    it 'should assign box imageImageView as the second subview of the controller\'s view. ' do
      controller.view.subviews[1].object_id.should.equal controller.box.object_id
    end

    it "should have a UITapGestureRecognizer that responds to a tap action." do
      controller.view.gestureRecognizers[0].class.should == UITapGestureRecognizer
    end
  end

  describe "SnapViewController's UITapGestureRecognizer gesture recognizer action #handle_tap" do
    it 'should move the center of the box after taping the view at location 200.0, 200.0 ' do
      box_center_before_tap = controller.box.center
      tap(controller.view, at: CGPointMake(200.0, 200.0), :times => 1, :touches => 1)
      box_center_after_tap = controller.box.center
      box_center_after_tap.x.should.be > box_center_before_tap.x
      box_center_after_tap.y.should.be > box_center_before_tap.y
    end
  end

   # Ivar check needs to floow previous tap test to be a meaningful test of @snap_behavior
   describe 'SnapViewController #init' do
     it 'should create the ivars @snap_behavior' do
       SpecHelper.query_ivars(controller, [{:ivar_instance => controller.instance_variable_get('@snap_behavior'), :ivar_class => UISnapBehavior}])
     end
   end
end
