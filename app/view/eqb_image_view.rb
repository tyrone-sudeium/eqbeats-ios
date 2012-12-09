class UIImageView
  attr_accessor :image_url

  def image_url=(url)
    @image_url = url
    load_image_from_url url
  end

  def load_image_from_url(url, placeholder = nil)
    url = NSURL.URLWithString(url) unless url.is_a? NSURL
    @image_url = url

    cached_image = App.delegate.cache.asset_for_string url.absoluteString
    return self.image = cached_image unless cached_image.nil?

    self.image = placeholder if self.image.nil?
    p url.absoluteString
    BW::HTTP.get(url.absoluteString) do |response|
      if response.ok?
        fetched_image = UIImage.imageWithData(response.body)
        App.delegate.cache.cache_asset(fetched_image, forString: url.absoluteString) unless fetched_image.nil?
        if response.url.eql? @image_url
          crossfade_to_image fetched_image
        end
      end
    end
  end

  def crossfade_to_image(other_image, duration = 0.5)
    if self.image.nil?
      self.image = other_image
      return
    end

    if self.image.equal? other_image
      return
    end
    animation = CABasicAnimation.animationWithKeyPath('contents')
    animation.duration = duration
    animation.fromValue = self.image.CGImage
    animation.toValue = other_image.CGImage
    self.layer.addAnimation animation, forKey: 'animateContents'
    self.image = other_image
  end
end

class EQBImageView < UIImageView
  
end
