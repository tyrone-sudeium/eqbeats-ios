class Playlist < EQBeats::ModelObject
  attr_accessor :name, :author, :tracks

  def initialize
    self.tracks = []
  end

end
