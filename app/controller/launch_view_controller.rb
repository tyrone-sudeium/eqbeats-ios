class LaunchViewController < UIViewController
  extend IB

  def viewWillAppear(animated)
    super
    self.navigationController.setNavigationBarHidden(true, animated: animated)
  end
end