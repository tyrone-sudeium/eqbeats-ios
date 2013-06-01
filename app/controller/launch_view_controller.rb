class LaunchViewController < UIViewController
  extend IB

  outlet :launch_background, LaunchBackgroundView
  outlet :progress_control, RoundProgressControl

  def viewDidLoad
    self.view.when_tapped do
      self.performSegueWithIdentifier('PushToTabBarController', sender:self)
    end
  end

  def viewWillAppear(animated)
    super
    self.navigationController.setNavigationBarHidden(true, animated: animated)
    self.launch_background.on :image_needed, -> do
      @@count ||= 0
      @@count = (@@count + 1) % 35
      UIImage.imageNamed("albumart/#{@@count}.jpg")
    end
  end
end