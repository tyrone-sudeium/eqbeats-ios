module EQBeats::Theme
  module_function

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

end

::Theme = ::EQBeats::Theme unless defined?(::Theme)