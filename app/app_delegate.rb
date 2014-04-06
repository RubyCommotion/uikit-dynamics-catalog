class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'
    table_controller = ExamplesTableController.alloc.init
    nav_controller = UINavigationController.alloc.initWithRootViewController(table_controller)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible
    true
  end
end
