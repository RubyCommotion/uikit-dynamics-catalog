describe GravitySpringController do

  tests GravitySpringController

  def controller
    @controller ||= GravitySpringController.alloc.init(DecorationView.alloc.init)
  end

  describe 'GravitySpringController #loadView' do
    it 'creates a DecorationView controller controller view' do
      controller.view.class.should.equal DecorationView
    end
  end
end
