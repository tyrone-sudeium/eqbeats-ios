module EQBeats::Theme
  module_function

  # # # Fonts # # #

  FONT_FACE = 'mplus-2c-regular'
  BOLD_FONT_FACE = 'mplus-2c-bold'
  SUPER_BOLD_FONT_FACE = 'mplus-2c-black'

  def normal_font_at_size(size)
    UIFont.fontWithName(FONT_FACE, size: size)
  end

  def bold_font_at_size(size)
    UIFont.fontWithName(BOLD_FONT_FACE, size: size)
  end

  def super_bold_font_at_size(size)
    UIFont.fontWithName(SUPER_BOLD_FONT_FACE, size: size)
  end

  # Returns the standard font at the provided font's size
  def adjust_font_face(font)
    if font.fontName.downcase.include? 'bold'
      UIFont.fontWithName(BOLD_FONT_FACE, size: font.pointSize)
    else
      UIFont.fontWithName(FONT_FACE, size: font.pointSize)
    end
  end

  # # # Icons, Buttons, Stretchable Things # # #

  def black_back_button_image
    UIImage.imageNamed('BackButton.png').stretchableImageWithLeftCapWidth(14, topCapHeight:0)
  end

  def black_back_button_highlighted_image
    UIImage.imageNamed('BackButtonHighlighted.png').stretchableImageWithLeftCapWidth(14, topCapHeight:0)
  end

  def play_button_image
    UIImage.imageNamed('Play.png')
  end

  def pause_button_image
    UIImage.imageNamed('Pause.png')
  end

end

::Theme = ::EQBeats::Theme unless defined?(::Theme)