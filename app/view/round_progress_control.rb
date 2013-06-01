=begin
class RoundProgressControlLayer < CALayer
  UNFINISHED_COLOR = '#88348B'.to_color
  FINISHED_COLOR = '#4134B8'.to_color

  # Normalized progress between 0.0 and 1.0.  Values above and below this
  # will result in undefined behaviour.
  # attr_accessor :progress

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
    angle = (progress * Math::PI * 2) - Math::PI

    UIGraphicsPushContext(context)

    unfinished_path = UIBezierPath.bezierPathWithOvalInRect(rect)
    UNFINISHED_COLOR.set
    unfinished_path.fill

    finished_path = UIBezierPath.new
    finished_path.moveToPoint(rect.center)
    finished_path.addLineToPoint(rect.top_center)
    finished_path.addArcWithCenter(rect.center,
                                   radius: rect.width,
                                   startAngle: -Math::PI / 2,
                                   endAngle: angle,
                                   clockwise: true)
    FINISHED_COLOR.set
    finished_path.fill

    UIGraphicsPopContext()
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
