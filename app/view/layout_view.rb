module Layout
  module LayoutView
    attr_accessor :maximumHeight
    attr_accessor :maximumWidth

    def layout_capable_subviews
      self.subviews.select { |x| x.respond_to?('desiredHeight') &&
        x.respond_to?('desiredWidth')}
    end

    def maximumHeight
      @maximumHeight ||= Float::MAX
    end

    def maximumWidth
      @maximumWidth ||= Float::MAX
    end

    def desiredHeight
      self.frame.size.height
    end

    def desiredWidth
      self.frame.size.width
    end

    def sizeToFit
      s = [[maximumWidth, desiredWidth].min,
                        [maximumHeight, desiredHeight].min]
      self.frame = [self.frame.origin, s]
    end
  end
end

class LayoutView < UIView
  include Layout::LayoutView
end

class LayoutLabel < UILabel
  include Layout::LayoutView
end

class VerticalExpandingLabel < LayoutLabel

  def desiredHeight
    return 0 if text.nil?
    text.sizeWithFont(font, constrainedToSize: [frame.size.width,Float::MAX], lineBreakMode: lineBreakMode).height
  end

end

class HorizontalExpandingLabel < LayoutLabel

  def desiredWidth
    return 0 if text.nil?
    text.sizeWithFont(font, constrainedToSize: [Float::MAX, frame.size.height], lineBreakMode: lineBreakMode).width
  end

end

class VerticalLayoutView < LayoutView

  def layoutSubviews
    super
    last_subview = nil
    layout_capable_subviews.each do |view|
      view.sizeToFit
      frame = view.frame
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

end

class HorizontalLayoutView < LayoutView

  def layoutSubviews
    super
    last_subview = nil
    layout_capable_subviews.each do |view|
      view.sizeToFit
      frame = view.frame
      if last_subview.nil?
        frame.origin.x = 0
      else
        frame.origin.x = last_subview.frame.origin.x + last_subview.frame.size.width
      end
      view.frame = frame
      last_subview = view
    end
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

class AnchorView < LayoutView
  attr_accessor :anchorPoint

  def anchorPoint
    @anchorPoint ||= CGPointMake(0,0)
  end

  def setAnchorPoint(p)
    if p.is_a? NSValue
      @anchorPoint = p.CGPointValue
    else
      @anchorPoint = p
    end
  end

  def layoutSubviews
    super
    if subviews.count != 1
      raise ArgumentError, 'AnchorView must have exactly one subview.'
    end
    subview = subviews[0]
    pt = anchorPoint
    subview.sizeToFit
    subFrame = subview.frame
    subFrame.x = (frame.width * pt.x) - (subFrame.width * pt.x)
    subFrame.y = (frame.height * pt.y) - (subFrame.height * pt.y)
    subview.frame = subFrame
  end

end
