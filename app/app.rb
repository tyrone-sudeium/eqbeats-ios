module BubbleWrap::App
  module_function

  def application_support_path
    app_support = library_path.stringByAppendingPathComponent 'Application Support'
    fm = NSFileManager.new
    unless fm.fileExistsAtPath appSupport
      fm.createDirectoryAtPath(app_support, 
        withIntermediateDirectories: false, 
        attributes: nil, 
        error: nil)
    end
    app_support
  end

  def cache_path
    path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
      NSUserDomainMask, true)[0]
    fm = NSFileManager.new
    unless fm.fileExistsAtPath path
      fm.createDirectoryAtPath(path, 
        withIntermediateDirectories: false, 
        attributes: nil, 
        error: nil)
    end
    path
  end

  def library_path
    NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true)[0]
  end

end
