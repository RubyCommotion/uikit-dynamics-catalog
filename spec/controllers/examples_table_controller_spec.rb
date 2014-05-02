describe ExamplesTableController do

  before do
    @help_method = SpecHelper.create_help_methods
  end

  tests ExamplesTableController

  describe '#viewDidLoad' do

    it 'sets the title' do
      controller.title.should.equal 'UIKit Dynamics Catalog Examples'
    end

    it 'sets the data source to self' do
      controller.tableView.dataSource.should.equal controller
    end

    it 'sets the delegate to self' do
      controller.tableView.delegate.should.equal controller
    end
  end

  describe '#tableView cellForRowAtIndexPath' do
    it 'returns a cell' do
      index_path = NSIndexPath.indexPathForRow(1, inSection: 1)
      controller.tableView(controller.tableView, cellForRowAtIndexPath: index_path).should.be.kind_of UITableViewCell
    end
  end

  describe '#tableView numberOfRowsInSection' do
    it 'returns an integer' do
      controller.tableView(controller.tableView, numberOfRowsInSection: 1).should.be.kind_of Integer
    end
  end

  describe 'data' do
    it 'returns an array' do
      controller.data.should.be.kind_of Array
    end
    it 'should contain entries for 10 controllers' do
      controller.data.size.should.equal 9
    end

    it 'should instantiate 10 view controller objects' do
      @help_method.view_controller_instances_exist(controller.data).should.equal true
    end

  end
end
