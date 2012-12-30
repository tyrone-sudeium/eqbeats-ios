class PlayerViewController < UIViewController
  extend IB

  outlet :play_pause_button, UIButton
  outlet :rewind_button,  UIButton
  outlet :forward_button, UIButton
  outlet :slider, UISlider
  outlet :name_label, UILabel
  outlet :elapsed_label, UILabel
  outlet :remaining_label, UILabel
  outlet :artist_label, UILabel
  outlet :queue_length_label, UILabel
  outlet :artwork_view, UIImageView
  outlet :back_button_item, UIBarButtonItem

  attr_accessor :observer

  def viewDidLoad
    super
    self.back_button_item.setBackgroundImage(Theme.black_back_button_image, forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault)
    self.back_button_item.setBackgroundImage(Theme.black_back_button_highlighted_image, forState:UIControlStateHighlighted, barMetrics:UIBarMetricsDefault)
  end

  def viewWillAppear(animated)
    super
    self.observer = EQBeats::AudioPlayerObserver.new
    AudioPlayer.observers << self.observer

    self.observer.on :elapsed_time_changed { update_slider; update_duration_labels }
    self.observer.on :playback_state_changed do
      p "playback_state: #{AudioPlayer.playback_state}"
      if self.observer.timing_interval.nil?
        duration = AudioPlayer.duration
        unless duration.nil? or !duration.valid? or duration.infinity?
          seconds = CMTimeGetSeconds(duration)
          self.observer.timing_interval = 1
        end
      end

      update_buttons
    end

    update_everything
  end

  def viewWillDisappear(animated)
    super
    self.observer.remove_all_events
    AudioPlayer.observers.delete self.observer
  end

  # Actions

  def backButtonAction
    self.navigationController.popViewControllerAnimated(true)
  end

  def update_everything
    update_slider
    update_duration_labels
    update_buttons
  end

  def update_slider
    duration = AudioPlayer.duration
    if !duration.valid? or duration.infinity?
      self.slider.setValue 0
      self.slider.setMinimumValue 0
      self.slider.setMaximumValue 0
      return
    end

    duration_seconds = CMTimeGetSeconds(duration)
    elapsed_seconds = CMTimeGetSeconds(AudioPlayer.elapsed_time)
    self.slider.setMaximumValue duration_seconds
    self.slider.setValue elapsed_seconds
  end

  def update_duration_labels
    duration = AudioPlayer.duration
    if !duration.valid? or duration.infinity?
      self.elapsed_label.hidden = true
      self.remaining_label.hidden = true
      self.queue_length_label.text = "1 of 1"
      return
    else
      self.elapsed_label.hidden = false
      self.remaining_label.hidden = false
    end

    duration_seconds = CMTimeGetSeconds(duration)
    elapsed_seconds = CMTimeGetSeconds(AudioPlayer.elapsed_time)
    remaining_seconds = (duration_seconds - elapsed_seconds).ceil
    self.elapsed_label.text = Time.at(elapsed_seconds.floor).gmtime.strftime('%M:%S')
    self.remaining_label.text = Time.at(remaining_seconds).gmtime.strftime('%M:%S')

    self.queue_length_label.text = "#{AudioPlayer.queue_position} of #{AudioPlayer.playback_queue.length}"
  end

  def update_buttons
    self.rewind_button.enabled = AudioPlayer.has_next_item?
    self.forward_button.enabled = AudioPlayer.has_previous_item?

    [self.rewind_button,self.forward_button].each do |button|
      if button.enabled?
        button.alpha = 1
      else
        button.alpha = 0.5
      end
    end

    if AudioPlayer.playing?
      self.play_pause_button.setImage(Theme.pause_button_image, forState:UIControlStateNormal)
    else
      self.play_pause_button.setImage(Theme.play_button_image, forState:UIControlStateNormal)
    end
  end

end