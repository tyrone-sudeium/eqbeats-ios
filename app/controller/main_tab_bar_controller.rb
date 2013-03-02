class MainTabBarController < UITabBarController
  extend IB
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


  def tabButtonAction(sender)
    if sender.tag < 4
      self.setSelectedIndex(sender.tag)
    else
      self.setSelectedViewController(self.moreNavigationController)
    end
    updateButtonSelectionState
  end

end