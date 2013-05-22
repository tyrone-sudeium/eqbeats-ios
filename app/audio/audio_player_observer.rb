class EQBeats::AudioPlayerObserver
  include EM::Eventable

  EVENTS = [
    :current_item_changed,
    :elapsed_time_changed,
    :playback_state_changed
  ]

  attr_accessor :timing_interval, :timer, :player

  def remove_all_events
    EVENTS.each do |event|
      # dealwithit.gif
      @__events__.delete event
    end
    remove_timer
  end

  def remove_timer
    unless self.player.nil? or self.timer.nil?
      self.player.removeTimeObserver(self.timer)
      self.timer = nil
      self.player = nil
    end
  end

end

module AudioPlayerObservingViewController
  attr_accessor :observer

  def viewWillAppear(animated)
    super
    self.observer = EQBeats::AudioPlayerObserver.new
    AudioPlayer.observers << self.observer
  end

end