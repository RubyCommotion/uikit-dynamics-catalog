class SpecHelper

  def self.view_controller_instances_exist(controllers)
    controller_test_results = true
    controllers.each do  |controller|
        controller_instance = controller[:controller].alloc.init
        unless controller_instance == UIViewController || UITableViewController
          controller_test_results = false
        end
      end
  controller_test_results
  end

  def self.window_cleanup
    @app = UIApplication.sharedApplication
    NSLog "The number of Windows: #{@app.windows.size}"
    @app.windows[0] = nil

  end

end
