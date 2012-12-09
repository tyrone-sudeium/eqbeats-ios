class Track < EQBeats::ModelObject
  attr_accessor :title, :artist, :download

  def file_path
    return mp3 unless File.exists? cache_path
    NSURL.fileURLWithPath(cache_path).absoluteString
  end

  def mp3
    @download[:mp3]
  end

  # quality, :thumb, :medium, :full
  def art_link(quality = :full)
    case quality
    when :full
      "#{@link}/art"
    when :medium
      "#{@link}/art/medium"
    when :thumb
      "#{@link}/art/thumb"
    end
    "#{@link}/art"
  end

  def cache_path
    "#{App.cache_path}/track_#{id}.mp3"
  end

end
