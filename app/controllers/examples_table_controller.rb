class ExampleTableController < UITableViewController
  def viewDidLoad
    super
    self.title = "UIKit Examples"
    self.view.backgroundColor = UIColor.whiteColor
    self.tableView.dataSource = self
    self.tableView.delegate = self
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @cell_identifier ||= "cell_identifier"
    cell = tableView.dequeueReusableCellWithIdentifier(@cell_identifier)
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @cellIdentifier)
    cell.textLabel.text = data[indexPath.row][:title]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    controller = data[indexPath.row][:controller].alloc.init
    navigationController.pushViewController(controller, animated: true)
  end

  def data
    [
      {
        title: "Gravity",
        controller: GravityViewController
      },
      {
        title: "Collision",
        controller: CollisionViewController
      },
      {
        title: "Snap",
        controller: SnapViewController
      }
    ]
  end
end
