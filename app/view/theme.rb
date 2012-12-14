module EQBeats::Theme
  module_function
  
  def normal_font_at_size(size)
    UIFont.fontWithName('mplus-1c', size: size)
  end

  def bold_font_at_size(size)
    UIFont.fontWithName('mplus-1c-bold', size: size)
  end

end

::Theme = ::EQBeats::Theme unless defined?(::Theme)