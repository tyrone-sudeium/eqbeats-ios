class UISearchBar
  def text_field
    self.subview_tree.flatten.select{|v| v.isKindOfClass(UITextField)}.last
  end
end