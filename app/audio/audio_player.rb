module EQBeats::AudioPlayer
  extend self
  
  # playback_queue is a list of Track model objects
  attr_accessor :playback_queue, :player

  def playback_queue=(queue)
    @playback_queue = queue
    self.queue_items = player_items_from_tracks(queue)
    self.player = nil
    # self.player.removeAllItems
    # self.queue_items.each do |item|
    #   self.player.insertItem(item, afterItem:nil)
    # end
  end

  def player
    @player ||= AVQueuePlayer.alloc.init
  end

  def toggle_play_pause
    if playing? then self.player.pause else self.player.play end
  end

  def stop
    self.player.stop
    set_audio_session_active false
  end

  def play
    set_audio_session_active true
    self.player.play
  end

  def next_track
    self.player.advanceToNextItem
  end

  def previous_track
    return unless queue_has_previous_item?
    index = self.queue_items.indexOfObject(self.player.items[0]) - 1
    items = self.queue_items.slice(index,self.queue_items.length)
    self.player.removeAllItems
    items.each do |item|
      self.player.insertItem(item, afterItem:nil)
    end
  end

  def set_audio_session_active(active)
    @audio_session ||= begin
      session = AVAudioSession.sharedInstance;
      session.setCategory(AVAudioSessionCategoryPlayback, error:nil)
      session
    end
    @audio_session.setActive(active, error:nil)
  end

  def playing?
    self.player.rate > 0
  end

  protected
  #module_function

  # queue_items is a list of AVPlayerItems
  attr_accessor :queue_items

  def queue_has_previous_item?
    return false if self.player.items.empty? or self.queue_items.count < 2
    self.queue_items.indexOfObject(self.player.items[0]) > 0
  end

  def player_items_from_tracks(tracks)
    tracks.map do |track|
      AVPlayerItem.playerItemWithURL track.asset_url
    end
  end

end
::AudioPlayer = EQBeats::AudioPlayer unless defined?(::AudioPlayer)