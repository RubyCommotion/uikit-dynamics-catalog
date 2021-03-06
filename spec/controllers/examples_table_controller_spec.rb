describe ExamplesTableController do

  before do
    @help_method = SpecHelper.create_help_methods
  end

  tests ExamplesTableController

  describe 'ExamplesTableController #viewDidLoad' do

    it 'should set the title' do
      controller.title.should.equal 'UIKit Dynamics Catalog Examples'
    end

    it 'should set the data source to self' do
      controller.tableView.dataSource.should.equal controller
    end

    it 'should set the delegate to self' do
      controller.tableView.delegate.should.equal controller
    end
  end

  describe 'ExamplesTableController #tableView cellForRowAtIndexPath' do
    it 'should return a cell' do
      index_path = NSIndexPath.indexPathForRow(1, inSection: 1)
      controller.tableView(controller.tableView, cellForRowAtIndexPath: index_path).should.be.kind_of UITableViewCell
    end
  end

  describe 'ExamplesTableController #tableView numberOfRowsInSection' do
    it 'should return an integer' do
      controller.tableView(controller.tableView, numberOfRowsInSection: 1).should.be.kind_of Integer
    end
  end

  describe 'ExamplesTableController data' do
    it 'should return an array' do
      controller.data.should.be.kind_of Array
    end
    it 'should contain entries for 10 controllers' do
      controller.data.size.should.equal 10
    end

    it 'should instantiate 10 view controller objects' do
      @help_method.view_controller_instances_exist(controller.data).should.equal true
    end
  end
end
