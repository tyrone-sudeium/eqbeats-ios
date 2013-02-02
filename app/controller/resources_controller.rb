module ResourcesController
  def self.set_image_view_for_track(imageView, track, quality = :full)
    if track.art_link(quality).nil?
      imageView.setImage(self.no_artwork_image_for_quality(quality))
    else
      imageView.load_image_from_url(NSURL.URLWithString(track.art_link(quality)), 
        placeholderImage: self.placeholder_image_for_quality(quality), 
        completed: -> (image, error, cacheType) {
          if image.nil? or not error.nil?
            imageView.setImage(self.no_artwork_image_for_quality(quality))
          end
        })
    end
  end

  def self.placeholder_image_for_quality(quality = :full)
    case quality
    when :full then return UIImage.imageNamed 'Downloading_Artwork.png'
    when :thumb then return UIImage.imageNamed 'Downloading_Artwork_Thumb.png'
    end
    UIImage.imageNamed 'Downloading_Artwork.png'
  end

  def self.no_artwork_image_for_quality(quality = :full)
    case quality
    when :full then return UIImage.imageNamed 'No_Artwork.png'
    when :thumb then return UIImage.imageNamed 'No_Artwork_Thumb.png'
    end
    UIImage.imageNamed 'No_Artwork.png'
  end

end

class UIImageView
  attr_accessor :loading_image_operation

  def load_image_from_url(url, placeholderImage: placeholder, completed: completion)
    cancel_current_image_load
    self.image = placeholder unless placeholder.nil?

    unless url.nil?
      self.loading_image_operation = SDWebImageManager.sharedManager.downloadWithURL(url,
        options: 0, progress: nil, completed: -> (image, error, cacheType, finished) {
          unless image.nil?
            self.image = image
            self.setNeedsLayout
          end
          if not completion.nil?
            completion.call(image, error, cacheType)
          end
        }
      )
    end
  end

  def cancel_current_image_load
    if not self.loading_image_operation.nil?
      self.loading_image_operation.cancel
      self.loading_image_operation = nil
    end
  end
end
