class ShadowedTextField < UITextField
  attr_accessor :shadowColor  # UIColor
  attr_accessor :shadowOffset # CGSize

  def drawTextInRect(rect)
    return super if shadowOffset.width == 0 && shadowOffset.height == 0
    ctx = UIGraphicsGetCurrentContext()
    CGContextSaveGState(ctx)
    colorspace = CGColorSpaceCreateDeviceRGB()
    color = self.shadowColor.CGColor
    CGContextSetShadowWithColor(ctx, shadowOffset, 0, color)
    super
    CGContextRestoreGState(ctx)
  end
end