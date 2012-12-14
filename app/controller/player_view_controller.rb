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
end