class MainTabBarController < UITabBarController
  extend IB
  include AudioPlayerObservingViewController
  attr_accessor :customTabBarView

  outlet_collection :buttons, UIButton
  outlet :rewind_button, UIButton
  outlet :play_pause_button, UIButton
  outlet :forward_button, UIButton

  def viewDidLoad
    super
    self.tabBar.items.each do |tabBarItem|
      tabBarItem.setFinishedSelectedImage(tabBarItem.image, withFinishedUnselectedImage:tabBarItem.image)
    end

    self.moreNavigationController.delegate = self
    self.customTabBarView = EQBeatsTabBarView.loadFromNibName(nil, bundle: nil, filesOwner: self)
    self.tabBar.addSubview(self.customTabBarView)
    self.tabBar.bringSubviewToFront(self.customTabBarView)
    self.moreNavigationController.navigationBar.setBackgroundImage(UIImage.imageNamed('NavigationBarBackground.png'), forBarMetrics: UIBarMetricsDefault)

    self.customTabBarView.songArtView.when_tapped do
      unless AudioPlayer.current_item.nil?
        player = self.storyboard.instantiateViewControllerWithIdentifier('NowPlaying')
        App.delegate.navigation_controller.pushViewController(player, animated:true)
      end
    end
  end

  def viewWillAppear(animated)
    super
    self.tabBar.bringSubviewToFront(self.customTabBarView)
    updateButtonSelectionState
    updatePlayingItem
    self.observer.on :current_item_changed do
      updatePlayingItem
    end
    self.observer.on :playback_state_changed do
      updatePlaybackButtons
      updatePlayingItem
    end
  end

  def viewWillDisappear(animated)
    super
    p self.observer.description
    self.observer.remove_all_events
    AudioPlayer.observers.delete self.observer
  end

  # Navigation Controller Delegate
  def navigationController(navController, willShowViewController: viewController, animated: animated)
    if navController == self.moreNavigationController
      navController.navigationBar.topItem.rightBarButtonItem = nil
    end
  end

  def updateButtonSelectionState
    self.buttons.each { |btn| btn.setSelected(false) }
    self.buttons[self.selectedIndex].setSelected(true)
    self.tabBar.bringSubviewToFront(self.customTabBarView)
  end

  def updatePlayingItem
    if AudioPlayer.current_item.nil?
      customTabBarView.songText = ""
      customTabBarView.artistLabel.text = ""
      customTabBarView.songArtView.image = nil
    else
      customTabBarView.songText = "#{AudioPlayer.current_item.title}"
      customTabBarView.artistLabel.text = "#{AudioPlayer.current_item.artist.name}"
      ResourcesController.set_image_view_for_track(customTabBarView.songArtView, AudioPlayer.current_item, :thumb)
    end
  end

  def updatePlaybackButtons
    self.rewind_button.enabled = AudioPlayer.has_previous_item?
    self.forward_button.enabled = AudioPlayer.has_next_item?

    # You can also rewind if your current track is loaded
    if AudioPlayer.duration.valid? and not AudioPlayer.duration.infinity?
      self.rewind_button.enabled = true
    elsif AudioPlayer.has_previous_item?
      self.rewind_button.enabled = true
    else
      self.rewind_button.enabled = false
    end

    [self.rewind_button,self.forward_button].each do |button|
      if button.enabled?
        button.alpha = 1
      else
        button.alpha = 0.5
      end
    end

    if shows_pause_icon?
      self.play_pause_button.setImage(Theme.tab_bar_pause_button_image, forState:UIControlStateNormal)
    else
      self.play_pause_button.setImage(Theme.tab_bar_play_button_image, forState:UIControlStateNormal)
    end
  end

  def shows_play_icon?
    !shows_pause_icon?
  end

  def shows_pause_icon?
    return true if AudioPlayer.playing? || AudioPlayer.autoplay
  end

  def tabButtonAction(sender)
    if sender.tag < 4
      self.setSelectedIndex(sender.tag)
    else
      self.setSelectedViewController(self.moreNavigationController)
    end
    updateButtonSelectionState
  end

  def toPlaybackControlsAction(sender)
    customTabBarView.scrollView.setContentOffset([customTabBarView.scrollView.frame.size.width, 0], animated: true)
  end

  def toTabBarControlsAction(sender)
    customTabBarView.scrollView.setContentOffset([0, 0], animated: true)
  end

  def playPauseButtonAction(sender)
    AudioPlayer.toggle_play_pause
  end

  def previousButtonAction(sender)
    AudioPlayer.previous_track
  end

  def nextButtonAction(sender)
    AudioPlayer.next_track
  end

end