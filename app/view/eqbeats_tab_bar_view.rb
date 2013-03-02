class EQBeatsTabBarView < UIView
  extend IB
  outlet :scrollView, UIScrollView
  outlet :contentView, UIView
  outlet :featuredButton, UIButton
  outlet :playlistsButton, UIButton
  outlet :searchButton, UIButton
  outlet :radioButton, UIButton
  outlet :moreButton, UIButton

  def awakeFromNib
    super
    self.scrollView.addSubview(self.contentView)
    self.scrollView.setContentSize(self.contentView.frame.size)
  end
end