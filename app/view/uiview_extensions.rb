class UIView
  # Creates a nested array structure containing this view and recursively,
  # all the subviews in tree.
  def subview_tree
    [self, self.subviews.map {|v| v.subview_tree }].reject{|x| x.nil? or x == []}
  end
end
