class UIView
  def self.loadFromNibName(nibNameOrNil, bundle: bundle, filesOwner: filesOwner)
    bundle = NSBundle.mainBundle if bundle.nil?
    nibNameOrNil = NSStringFromClass(self) if nibNameOrNil.nil?
    return nil if bundle.pathForResource(nibNameOrNil, ofType: "nib").nil?
    topLevelObjects = bundle.loadNibNamed(nibNameOrNil, owner: filesOwner, options: nil)
    topLevelObjects.each { |obj| return obj if obj.is_a?(self) }
    return nil
  end

  def self.loadFromNibName(nibNameOrNil, bundle: bundle)
    return self.loadFromNibName(nibNameOrNil, bundle: bundle, filesOwner: nil)
  end

  def self.loadFromNibName(nibNameOrNil)
    return self.loadFromNibName(nibNameOrNil, bundle: nil, filesOwner: nil)
  end
end