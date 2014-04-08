describe "Application 'uikit'" do
  before do
    @app = UIApplication.sharedApplication
  end

  # TODO need to setup a window and controller cleanup method
  it "has zero window" do
    @app.windows.size.should == 0
  end
end
