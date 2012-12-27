class UIView
  def subview_tree
    [self, self.subviews.map {|v| v.subview_tree }].reject{|x| x.nil? or x == []}
  end
end
