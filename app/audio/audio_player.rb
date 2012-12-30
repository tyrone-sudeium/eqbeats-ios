module EQBeats::AudioPlayer
  include BW::KVO
  extend self

  # Overriding observe
  def observe(target, key_path, &block)
    @targets ||= {}
    options = BW::KVO::DEFAULT_OPTIONS | NSKeyValueObservingOptionInitial
    target.addObserver(self, forKeyPath:key_path, options:options, context:nil) unless registered?(target, key_path)
    add_observer_block(target, key_path, &block)
  end

  TIMING_INTERVAL = 0.1
  NSEC_PER_SEC = 1000000000
  PLAYBACK_STATES = [
    :playback_unavailable,
    :loading,
    :ready_to_play,
    :playing,
  ]
  
  # playback_queue is a list of Track model objects
  attr_accessor :playback_queue, :player, :observers
  attr_accessor :playback_state

  def playback_queue=(queue)
    @playback_queue = queue
    self.queue_items = player_items_from_tracks(queue)
    self.player = nil
  end

  def player
    if @player.nil?
      self.player = AVQueuePlayer.queuePlayerWithItems self.queue_items
    end
    @player
  end

  def player=(player)
    unless @player.nil?
      unless @player.currentItem.nil?
        unobserve(@player.currentItem, 'status')
      end
      unobserve(@player, 'currentItem')
      unobserve(@player, 'rate')
      @player.removeAllitems
    end
    @player = player
    return if player.nil?
    p 'adding observers'

    observe_block = -> notification {
      p 'current item changed'
      new_item = self.player.currentItem
      unobserve(@old_item, 'status') unless @old_item.nil?
      observe(new_item, 'status') do |old_status, new_status|
        p 'status changed'
        update_playback_state
        if new_status == AVPlayerStatusReadyToPlay
          update_observer_timers
        end
      end
      self.observers.each do |obs|
        obs.trigger :current_item_changed
      end
      @old_item = self.player.currentItem
    }

    @item_observer = App.notification_center.observe AVPlayerItemDidPlayToEndTimeNotification, &observe_block

    observe(@player, 'rate') do |old_item, new_item|
      p 'rate changed'
      update_playback_state
    end
    update_observer_timers
    observe_block.call(nil) unless @player.currentItem.nil?
  end

  def playback_state=(state)
    if state != @playback_state
      @playback_state = state
      self.observers.each do |obs|
        obs.trigger :playback_state_changed
      end
    end
    @playback_state = state
  end

  def observers
    @observers ||= []
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

  def elapsed_time
    return KCMTimeInvalid if self.player.currentItem.status != AVPlayerItemStatusReadyToPlay
    self.player.currentItem.currentTime
  end

  def duration
    if self.player.currentItem.nil? or self.player.currentItem.status != AVPlayerItemStatusReadyToPlay
      return KCMTimeInvalid
    else
      self.player.currentItem.duration
    end
  end

  protected

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

  def update_observer_timers
    self.observers.each do |obs|
      obs.remove_timer
      unless obs.timing_interval.nil? or obs.timing_interval <= 0
        obs.player = @player
        obs.timer = @player.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(obs.timing_interval, NSEC_PER_SEC), 
          queue:nil, 
          usingBlock: -> time {
            obs.trigger :elapsed_time_changed
          }
        )
      end
    end
  end

  def update_playback_state
    if self.player.currentItem.nil?
      self.playback_state = :playback_unavailable
    else
      case self.player.currentItem.status
      when AVPlayerItemStatusUnknown
        self.playback_state = :loading
      when AVPlayerItemStatusFailed
        self.playback_state = :playback_unavailable
      when AVPlayerItemStatusReadyToPlay
        if playing?
          self.playback_state = :playing
        else
          self.playback_state = :ready_to_play
        end
      end
    end
  end

end

::AudioPlayer = EQBeats::AudioPlayer unless defined?(::AudioPlayer)