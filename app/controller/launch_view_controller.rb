class LaunchViewController < UIViewController
  extend IB

  outlet :launch_background, LaunchBackgroundView

  def viewWillAppear(animated)
    super
    self.navigationController.setNavigationBarHidden(true, animated: animated)
    self.launch_background.on :image_needed, -> do
      @@count ||= 0
      @@count = (@@count + 1) % 175
      p "albumart/#{@@count}.png"
      UIImage.imageNamed("albumart/#{@@count}.png")
    end
  end
end