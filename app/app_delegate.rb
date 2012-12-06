class AppDelegate
  attr_accessor :api, :audio_player
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName('MainStoryboard', bundle: nil)
    rootVC = storyboard.instantiateInitialViewController
    @window.rootViewController = rootVC
    @window.makeKeyAndVisible
    true
  end

  def api
    @api ||= EQBeats::API.new(EQBeats::API_BASE_URL)
  end

  def audio_player
    @audio_player ||= EQBeats::AudioPlayer.new
  end
end
