class AppDelegate
  attr_accessor :api, :audio_player, :cache
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

  def cache
    @cache ||= DragonCache.new
  end

  def setup_appearance
    bold_font_19 = Theme.bold_font_at_size 19
    bold_font_14 = Theme.bold_font_at_size 14
    font_14 = Theme.normal_font_at_size 14
    UINavigationBar.appearance.titleTextAttributes = { 
      UITextAttributeFont => bold_font_19,
      UITextAttributeTextColor => BW.rgb_color(224, 216, 255) 
    }
    UINavigationBar.appearance.tintColor = BW.rgb_color(23, 15, 52)
  end
end
