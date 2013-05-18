class EQBNavigationController < UINavigationController

  def viewDidLoad
    self.navigationBar.setBackgroundImage(UIImage.imageNamed('NavigationBarBackground.png'), forBarMetrics: UIBarMetricsDefault)

    super
  end

end
