class MainTabBarController < UITabBarController

  def viewDidLoad
    super
    self.tabBar.items.each do |tabBarItem|
      tabBarItem.setFinishedSelectedImage(tabBarItem.image, withFinishedUnselectedImage:tabBarItem.image)
    end

    self.moreNavigationController.delegate = self
  end

  def viewWillAppear(animated)
    super
  end

  # Navigation Controller Delegate
  def navigationController(navController, willShowViewController: viewController, animated: animated)
    if navController == self.moreNavigationController
      navController.navigationBar.topItem.rightBarButtonItem = nil
    end
  end

end