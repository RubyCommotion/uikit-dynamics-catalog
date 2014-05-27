class ExamplesTableController < UITableViewController

  def init
    self
  end

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
    # each controller must have its own unique decoration view object
    if data[indexPath.row][:inject_decoration_view]
      controller = data[indexPath.row][:controller].alloc.init(DecorationView.alloc.init)
    else
      controller = data[indexPath.row][:controller].alloc.init
    end
    navigationController.pushViewController(controller, animated: true)
  end

  def data
    [
      {title: 'Attachments + Collision',
        controller: AttachmentsView,
        inject_decoration_view: true
      },
      {
        title: 'Continuous Push + Collision',
        controller: ContinuousPushViewController,
        inject_decoration_view: true
      },
      {title: 'Custom Dynamic Item',
        controller: CustomDynamicItemViewController,
        inject_decoration_view: true
      },
      {
        title: 'Gravity',
        controller: GravityViewController,
        inject_decoration_view: false
      },
      {
        title: 'Gravity + Collision',
        controller: CollisionViewController,
        inject_decoration_view: false
      },
      {
        title: "Gravity Spring",
        controller: GravitySpringController,
        inject_decoration_view: true
      },
      {
        title: 'Instantaneous Push + Collision',
        controller: InstantaneousPushViewController,
        inject_decoration_view: true
      },
      {
        title: 'Item Properties',
        controller: ItemPropertiesViewController,
        inject_decoration_view: false
      },
      {
        title: 'Pendulum (Composite Behavior)',
        controller: PendulumViewController,
        inject_decoration_view: true
      },
      {
        title: 'Snap',
        controller: SnapViewController,
        inject_decoration_view: false
      }
    ]
  end
end
