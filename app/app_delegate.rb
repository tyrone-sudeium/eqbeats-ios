class AppDelegate
  attr_accessor :api, :audio_player
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName('MainStoryboard', bundle: nil)
    rootVC = storyboard.instantiateInitialViewController
    @window.rootViewController = rootVC
    @window.makeKeyAndVisible

    setup_appearance

    true
  end

  def api
    @api ||= EQBeats::API.new(EQBeats::API_BASE_URL)
  end

  def audio_player
    @audio_player ||= EQBeats::AudioPlayer.new
  end

  def setup_appearance
    UINavigationBar.appearance.titleTextAttributes = { UITextAttributeFont => UIFont.fontWithName('mplus-1c-bold', size: 18) }
  end
end
