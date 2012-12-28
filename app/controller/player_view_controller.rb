class PlayerViewController < UIViewController
  extend IB

  outlet :play_pause_button, UIButton
  outlet :rewind_button,  UIButton
  outlet :forward_button, UIButton
  outlet :slider, UISlider
  outlet :name_label, UILabel
  outlet :elapsed_label, UILabel
  outlet :remaining_label, UILabel
  outlet :artist_label, UILabel
  outlet :artwork_view, UIImageView
  outlet :back_button_item, UIBarButtonItem

  def viewDidLoad
    super
    self.back_button_item.setBackgroundImage(Theme.black_back_button_image, forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault)
    self.back_button_item.setBackgroundImage(Theme.black_back_button_highlighted_image, forState:UIControlStateHighlighted, barMetrics:UIBarMetricsDefault)
  end

  # Actions

  def backButtonAction
    self.navigationController.popViewControllerAnimated(true)
  end

end