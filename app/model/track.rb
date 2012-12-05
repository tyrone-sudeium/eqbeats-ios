class Track < EQBeats::ModelObject
  attr_accessor :title, :artist, :download

  def mp3
    @download[:mp3]
  end

  def art_link
    "#{@link}/art"
  end

end
