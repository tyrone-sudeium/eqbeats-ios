class MainTabBarController < UITabBarController
  extend IB
  include AudioPlayerObservingViewController
  attr_accessor :customTabBarView

  outlet_collection :buttons, UIButton

  def viewDidLoad
    super
    self.tabBar.items.each do |tabBarItem|
      tabBarItem.setFinishedSelectedImage(tabBarItem.image, withFinishedUnselectedImage:tabBarItem.image)
    end

    self.moreNavigationController.delegate = self
    self.customTabBarView = EQBeatsTabBarView.loadFromNibName(nil, bundle: nil, filesOwner: self)
    self.tabBar.addSubview(self.customTabBarView)
    self.tabBar.bringSubviewToFront(self.customTabBarView)
  end

  def viewWillAppear(animated)
    super
    self.tabBar.bringSubviewToFront(self.customTabBarView)
    updateButtonSelectionState
    updatePlayingItem
    self.observer.on :current_item_changed do
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

  end

  def previousButtonAction(sender)

  end

  def nextButtonAction(sender)

  end

end