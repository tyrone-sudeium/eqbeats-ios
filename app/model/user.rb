class User < EQBeats::ModelObject
  attr_accessor :name, :tracks, :playlists, :favorites

  def description
    "<User name:#{@name}>"
  end
end
