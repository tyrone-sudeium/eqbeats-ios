class UIImage
  def memory_cost
    img = self.CGImage
    CGImageGetBytesPerRow(img) * CGImageGetHeight(img)
  end
end

class DragonCache
  MAXIMUM_MEMORY_USAGE = 10485760

  attr_accessor :memory_cache

  def initialize(cache_dir = 'dragon')
    @hoard = cache_dir
    @memory_cache = NSCache.alloc.init
    @memory_cache.setTotalCostLimit(MAXIMUM_MEMORY_USAGE)
  end

  def dragon_path
    "#{App.cache_path}/#{@hoard}"
  end

  def cache_asset(image, forString: string)
    @memory_cache.setObject(image, forKey: string, cost: image.memory_cost)
    EM.schedule {
      data = UIImagePNGRepresentation(image)
      error = Pointer.new(:object)
      data.writeToFile(asset_path(string), options: NSDataWritingAtomic, error: error)
      unless error.nil?
        p error[0]
      end
    }
  end

  def asset_cached?(string)
    return true unless @memory_cache.objectForKey(string).nil?
    File.exists? asset_path(string)
  end

  def asset_for_string(string)
    cached_object = @memory_cache.objectForKey(string)
    return cached_object unless cached_object.nil?

    cached_object = UIImage.imageWithContentsOfFile(asset_path(string))
    @memory_cache.setObject(cached_object, forKey: string, cost: cached_object.memory_cost) unless cached_object.nil?
    cached_object
  end

  def asset_path(string)
    unless Dir.exists? dragon_path
      Dir.mkdir(dragon_path)
    end
    hash = string.dataUsingEncoding(NSUTF8StringEncoding).MD5
    "#{dragon_path}/#{hash}"
  end

  def clear!
    NSFileManager.defaultManager.removeItemAtPath(dragon_path, error: nil)
  end

end
