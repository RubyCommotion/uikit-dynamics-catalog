class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    table_controller = ExampleTableController.alloc.init
    nav_controller = UINavigationController.alloc.initWithRootViewController(table_controller)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible
    true
  end
end
