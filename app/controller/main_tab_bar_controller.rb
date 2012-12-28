class MainTabBarController < UITabBarController

  def viewDidLoad
    super
    self.tabBar.items.each do |tabBarItem|
      tabBarItem.setFinishedSelectedImage(tabBarItem.image, withFinishedUnselectedImage:tabBarItem.image)
    end
  end

  def viewWillAppear(animated)
    super
  end

end