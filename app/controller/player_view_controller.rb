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
          self.observer.timing_interval = 0.5 * seconds / self.slider.frame.size.width
        end
      end
    end
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

  def update_slider
    duration = AudioPlayer.duration
    if !duration.valid? or duration.infinity?
      self.slider.setValue 0
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
      return
    end

    duration_seconds = CMTimeGetSeconds(duration)
    elapsed_seconds = CMTimeGetSeconds(AudioPlayer.elapsed_time)
    self.elapsed_label.text = Time.at(elapsed_seconds).gmtime.strftime('%M:%S')
    self.remaining_label.text = Time.at(duration_seconds - elapsed_seconds).gmtime.strftime('%M:%S')
  end

end