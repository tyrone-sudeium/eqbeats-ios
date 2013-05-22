class Track < EQBeats::ModelObject
  attr_accessor :title, :artist, :download, :player_item

  def asset_url
    return NSURL.URLWithString(mp4) unless cached?
    NSURL.fileURLWithPath(cache_path).absoluteString
  end

  def mp3
    self.download[:mp3]
  end

  def mp4
    "#{self.download[:aac]}"
  end

  # quality, :thumb, :medium, :full
  def art_link(quality = :full)
    case quality
    when :full
      "#{self.link}/art"
    when :medium
      "#{self.link}/art/medium"
    when :thumb
      "#{self.link}/art/thumb"
    else
      "#{self.link}/art"
    end
  end

  def cache_path
    "#{App.cache_path}/track_#{id}.m4a"
  end

  def cached?
    File.exists? cache_path
  end

  def player_item
    @player_item ||= AVPlayerItem.playerItemWithURL file_path
    @player_item
  end

end
