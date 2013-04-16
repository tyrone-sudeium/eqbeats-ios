class EQBeatsTabBarView < UIView
  extend IB
  outlet :scrollView, UIScrollView
  outlet :contentView, UIView
  outlet :featuredButton, UIButton
  outlet :playlistsButton, UIButton
  outlet :searchButton, UIButton
  outlet :radioButton, UIButton
  outlet :moreButton, UIButton
  outlet :artistLabel, UILabel
  outlet :songLabel, MarqueeLabel
  outlet :songArtView, UIImageView
  outlet :shadowView, UIView

  def awakeFromNib
    super
    contentView.setBackgroundColor(UIColor.clearColor)
    scrollView.addSubview(self.contentView)
    scrollView.setContentSize(self.contentView.frame.size)
    shadowLayer = songArtView.layer
    shadowLayer.cornerRadius = 3
    shadowLayer.shadowColor = UIColor.blackColor.CGColor
    shadowLayer.shadowPath = UIBezierPath.bezierPathWithRoundedRect(songArtView.bounds, cornerRadius:3).CGPath
    shadowLayer.shadowOffset = [0,1]
    shadowLayer.shadowOpacity = 0.6
    shadowLayer.shouldRasterize = true
    shadowLayer.shadowRadius = 2
    shadowLayer.rasterizationScale = UIScreen.mainScreen.scale
    shadowLayer.masksToBounds = false
    songArtView.layer.cornerRadius = 3
  end

  def songText=(text)
    maxSize = [Float::MAX, songLabel.frame.size.height]
    desiredSize = text.sizeWithFont(songLabel.font, constrainedToSize:maxSize, lineBreakMode:songLabel.lineBreakMode)
    if desiredSize.width >= songLabel.frame.size.width
      songLabel.marqueeType = MLContinuous
      songLabel.textAlignment = UITextAlignmentCenter
    else
      songLabel.marqueeType = MLLeftRight
      songLabel.textAlignment = UITextAlignmentLeft
    end
    songLabel.text = text
  end

end