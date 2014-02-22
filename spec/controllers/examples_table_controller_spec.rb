describe ExamplesTableController do
  before do
    @subject = ExamplesTableController.new
  end

  describe "#viewDidLoad" do
    before do
      @subject.viewDidLoad
    end

    it "sets the title" do
      @subject.title.should.equal "UIKit Examples"
    end

    it "sets the data source to self" do
      @subject.tableView.dataSource.should.equal @subject
    end

    it "sets the delegate to self" do
      @subject.tableView.delegate.should.equal @subject
    end
  end

  describe "#tableView cellForRowAtIndexPath" do
    it "returns a cell" do
      index_path = NSIndexPath.indexPathForRow(1, inSection: 1)
      @subject.tableView(@subject.tableView, cellForRowAtIndexPath: index_path).should.be.kind_of UITableViewCell
    end
  end

  describe "#tableView numberOfRowsInSection" do
    it "returns an integer" do
      @subject.tableView(@subject.tableView, numberOfRowsInSection: 1).should.be.kind_of Integer
    end
  end

  describe "data" do
    it "returns an array" do
      @subject.data.should.be.kind_of Array
    end
  end
end
