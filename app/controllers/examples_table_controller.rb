class ExamplesTableController < UITableViewController
  def viewDidLoad
    super
    self.title = 'UIKit Dynamics Catalog Examples'
    self.view.backgroundColor = UIColor.whiteColor
    self.tableView.dataSource = self
    self.tableView.delegate = self
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @cell_identifier ||= 'cell_identifier'
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
      {title: 'Attachments + Collision',
        controller: AttachmentsView
      },
      {
        title: 'Continuous Push + Collision',
        controller: ContinuousPushViewController
      },
      {title: 'Custom Dynamic Item',
        controller: CustomDynamicItemViewController
      },
      {
        title: 'Gravity',
        controller: GravityViewController
      },
      {
        title: 'Gravity + Collision',
        controller: CollisionViewController
      },
      {
        title: 'Instantaneous Push + Collision',
        controller: InstantaneousPushViewController
      },
      {
        title: 'Item Properties',
        controller: ItemPropertiesViewController
      },
      {
        title: 'Pendulum (Composite Behavior)',
        controller: PendulumViewController
      },
      {
        title: 'Snap',
        controller: SnapViewController
      }
    ]
  end
end
