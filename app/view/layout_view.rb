module LayoutView
  def layout_capable_subviews
    self.subviews.select { |x| x.respondsToSelector('desiredHeight') &&
      x.respondsToSelector('desiredWidth')}
  end
end

class VerticalLayoutView < UIView
  include LayoutView

  def layoutSubviews
    super
    last_subview = nil
    layout_capable_subviews.each do |view|
      frame = view.frame
      frame.size.height = view.desiredHeight
      if last_subview.nil?
        frame.origin.y = 0
      else
        frame.origin.y = last_subview.frame.origin.y + last_subview.frame.size.height
      end
      view.frame = frame
      last_subview = view
    end
  end

  def desiredHeight
    total = 0
    first = true
    layout_capable_subviews.each do |view|
      first = false; total += view.frame.origin.y if first
      total += view.desiredHeight
    end
    total
  end

  def desiredWidth
    self.frame.size.width
  end
end

class HorizontalLayoutView < UIView
  include LayoutView

  def layoutSubviews
    super
    last_subview = nil
    layout_capable_subviews.each do |view|
      frame = view.frame
      frame.size.width = view.desiredWidth
      if last_subview.nil?
        frame.origin.x = 0
      else
        frame.origin.x = last_subview.frame.origin.x + last_subview.frame.size.width
      end
      view.frame = frame
      last_subview = view
    end
  end

  def desiredHeight
    self.frame.size.height
  end

  def desiredWidth
    total = 0
    first = true
    layout_capable_subviews.each do |view|
      first = false; total += view.frame.origin.x if first
      total += view.desiredWidth
    end
    total
  end

end
