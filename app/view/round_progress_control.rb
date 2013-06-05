=begin
class RoundProgressControlLayer < CALayer
  UNFINISHED_COLOR = '#88348B'.to_color
  FINISHED_COLOR = '#4134B8'.to_color
  OUTLINE_COLOR = '#44165E'.to_color

  # Normalized progress between 0.0 and 1.0.  Values above and below this
  # will result in undefined behaviour.
  attr_accessor :progress

  def init
    super
    self.progress = 0
    self
  end

  def self.needsDisplayForKey(key)
    if key == 'progress'
      return true
    end
    super
  end

  def workingLayer
    self.presentationLayer || self
  end

  def actionForKey(key)
    if key == 'progress'
      anim = CABasicAnimation.animationWithKeyPath(key)
      anim.setFromValue(self.workingLayer.valueForKey(key))

      return anim
    end
    super
  end

  def drawInContext(context)
    super
    drawArcsInContext(context)
    drawStopInContext(context)
  end

  def drawArcsInContext(context)
    rect = self.bounds
    progress = self.workingLayer.valueForKey('progress')
    angle = (progress * Math::PI * 2) - (Math::PI / 2.0)

    CGContextSetFillColorWithColor(context, UNFINISHED_COLOR.CGColor)
    CGContextFillEllipseInRect(context, rect)
    
    center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
    path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, center.x, center.y)
    CGPathAddArc(path, nil, center.x, center.y, rect.size.width / 2.0, -Math::PI/2, angle, false)
    CGPathAddLineToPoint(path, nil, center.x, center.y)
    CGPathCloseSubpath(path)
    CGContextAddPath(context, path)

    CGContextSetFillColorWithColor(context, FINISHED_COLOR.CGColor)
    CGContextFillPath(context)
    
    CGContextSetStrokeColorWithColor(context, OUTLINE_COLOR.CGColor)
    CGContextSetLineWidth(context, 2.0)
    CGContextStrokeEllipseInRect(context, rect.shrink([1,1]))
  end

  def drawStopInContext(context)
    rect = self.bounds
    rect = rect.shrink([rect.width/3,rect.height/3]).round
    CGContextSetFillColorWithColor(context, 'red'.to_color.CGColor)
    CGContextFillRect(context, rect)
  end

end
=end

class RoundProgressControl < UIControl

  def awakeFromNib
    super
    self.layer.setContentsScale(UIScreen.mainScreen.scale)
  end

  def self.layerClass
    RoundProgressControlLayer
  end

  def progress
    self.layer.progress
  end

  # Animatable.
  def progress=(progress)
    self.layer.setValue(progress, forKey: 'progress')
  end

  def didMoveToSuperview
    if !self.superview.nil?
      self.layer.setNeedsDisplay
    end
  end

end
