class UIView
  # Creates a nested array structure containing this view and recursively,
  # all the subviews in tree.
  def subview_tree
    [self, self.subviews.map {|v| v.subview_tree }].reject{|x| x.nil? or x == []}
  end

  # Loads from a nib whose xib name matches the class name.
  def self.load_from_nib(nib_name = nil, bundle = nil, files_owner = nil)
    nib_name = NSStringFromClass(self.class) if nib_name.nil?
    bundle = NSBundle.mainBundle if bundle.nil?
    return nil if bundle.pathForResource(nib_name, ofType: 'nib').nil?
    bundle.loadNibNamed(nib_name, owner: files_owner, options: nil).each do |object|
      return object if object.is_a? self.class
    end
  end
  nil
end
