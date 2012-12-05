class Playlist < EQBeats::ModelObject
  attr_accessor :name, :author, :tracks

  def description
    "<Playlist name:#{@name}>"
  end

end
