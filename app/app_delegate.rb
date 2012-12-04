class AppDelegate
  attr_accessor :api
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UIViewController.alloc.init
    @window.makeKeyAndVisible

    self.api.get_user 11, -> a {
      puts a.inspect
    }
    true
  end

  def api
    @api ||= EQBeats::API.new(EQBeats::API_BASE_URL)
  end
end
