class AppDelegate
  attr_accessor :api, :audio_player, :cache, :navigation_controller
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = EQBeatsWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName('MainStoryboard', bundle: nil)
    rootVC = storyboard.instantiateInitialViewController
    self.navigation_controller = rootVC
    @window.rootViewController = rootVC
    @window.makeKeyAndVisible

    NSUserDefaults.standardUserDefaults['UserAgent'] = "EQBeats-iOS #{App.version}"

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
    bold_font_19 = Theme.bold_font_at_size 19
    bold_font_14 = Theme.bold_font_at_size 14
    font_14 = Theme.normal_font_at_size 14
    UINavigationBar.appearance.titleTextAttributes = { 
      UITextAttributeFont => Theme.super_bold_font_at_size(17),
      UITextAttributeTextColor => BW.rgb_color(224, 216, 255) 
    }
    UINavigationBar.appearance.tintColor = BW.rgb_color(23, 15, 52)
    UITabBar.appearance.setBackgroundImage(UIImage.imageNamed('TabBarBackground.png'))
    UITabBar.appearance.setSelectionIndicatorImage(nil)
    backBtnImage = UIImage.imageNamed('NavigationBackButtonNormal.png')
    backBtnImage = backBtnImage.resizableImageWithCapInsets([0,14,0,6])
    backBtnImageHighlighted = UIImage.imageNamed('NavigationBackButtonHighlighted.png')
    backBtnImageHighlighted = backBtnImageHighlighted.resizableImageWithCapInsets([0,14,0,6])

    UIBarButtonItem.appearance.setBackButtonBackgroundImage(backBtnImage, forState: UIControlStateNormal, barMetrics: UIBarMetricsDefault)
    UIBarButtonItem.appearance.setBackButtonBackgroundImage(backBtnImageHighlighted, forState: UIControlStateHighlighted, barMetrics: UIBarMetricsDefault)
    
  end
end
