class PlayerViewController < UIViewController
  extend IB
  include AudioPlayerObservingViewController

  outlet :play_pause_button, UIButton
  outlet :rewind_button,  UIButton
  outlet :forward_button, UIButton
  outlet :slider, UISlider
  outlet :name_label, MarqueeLabel
  outlet :elapsed_label, UILabel
  outlet :remaining_label, UILabel
  outlet :artist_label, UILabel
  outlet :queue_length_label, UILabel
  outlet :artwork_view, UIImageView
  outlet :back_button_item, UIBarButtonItem
  outlet :volume_view, MPVolumeView
  outlet :fake_volume_slider, UISlider
  outlet :navigationBar, UINavigationBar

  def viewDidLoad
    super
    self.navigationBar.setBackgroundImage(UIImage.imageNamed('NavigationBarBackground.png'), forBarMetrics: UIBarMetricsDefault)
    self.back_button_item.setBackgroundImage(Theme.back_button_image, forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault)
    self.back_button_item.setBackgroundImage(Theme.back_button_image_highlighted, forState:UIControlStateHighlighted, barMetrics:UIBarMetricsDefault)

    if Device.simulator?
      self.fake_volume_slider.hidden = false
    end
  end

  def viewWillAppear(animated)
    super

    self.observer.on :elapsed_time_changed { update_slider; update_labels }

    self.observer.on :playback_state_changed do
      p "playback_state: #{AudioPlayer.playback_state}"
      update_buttons
    end

    self.observer.on :current_item_changed do
      update_everything
    end
    self.observer.timing_interval = 1

    update_everything
    AudioPlayer.update_observers
  end

  def viewWillDisappear(animated)
    super
    p self.observer.description
    self.observer.remove_all_events
    AudioPlayer.observers.delete self.observer
    AudioPlayer.update_observers
  end

  def viewDidAppear(animated)
    super
    update_everything
  end

  # Actions

  def backButtonAction
    self.navigationController.popViewControllerAnimated(true)
  end

  def previousButtonAction
    AudioPlayer.previous_track
  end

  def nextButtonAction
    AudioPlayer.next_track
  end

  def playPauseButtonAction
    AudioPlayer.toggle_play_pause
  end

  def update_everything
    update_slider
    update_labels
    update_buttons
    update_album_art
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

  def update_labels
    self.queue_length_label.text = "#{AudioPlayer.queue_position} of #{AudioPlayer.playback_queue.length}"
    self.name_label.text = "#{AudioPlayer.current_item.title}"
    self.artist_label.text = "#{AudioPlayer.current_item.artist.name}"

    duration = AudioPlayer.duration
    if !duration.valid? or duration.infinity?
      self.elapsed_label.text = "00:00"
      self.remaining_label.text = "--:--"
      if AudioPlayer.queue_position == 0 or AudioPlayer.playback_queue.length == 0
        self.queue_length_label.text = "1 of 1"
      end
      return
    end

    duration_seconds = CMTimeGetSeconds(duration)
    elapsed_seconds = CMTimeGetSeconds(AudioPlayer.elapsed_time)
    remaining_seconds = (duration_seconds - elapsed_seconds).ceil
    self.elapsed_label.text = Time.at(elapsed_seconds.floor).gmtime.strftime('%M:%S')
    self.remaining_label.text = Time.at(remaining_seconds).gmtime.strftime('%M:%S')
  end

  def update_buttons
    self.rewind_button.enabled = AudioPlayer.has_previous_item?
    self.forward_button.enabled = AudioPlayer.has_next_item?

    # You can also rewind if your current track is loaded
    if AudioPlayer.duration.valid? and not AudioPlayer.duration.infinity?
      self.rewind_button.enabled = true
    elsif AudioPlayer.has_previous_item?
      self.rewind_button.enabled = true
    else
      self.rewind_button.enabled = false
    end

    [self.rewind_button,self.forward_button].each do |button|
      if button.enabled?
        button.alpha = 1
      else
        button.alpha = 0.5
      end
    end

    if shows_pause_icon?
      self.play_pause_button.setImage(Theme.pause_button_image, forState:UIControlStateNormal)
    else
      self.play_pause_button.setImage(Theme.play_button_image, forState:UIControlStateNormal)
    end
  end

  def shows_play_icon?
    !shows_pause_icon?
  end

  def shows_pause_icon?
    return true if AudioPlayer.playing? || AudioPlayer.autoplay
  end

  def update_album_art
    ResourcesController.set_image_view_for_track(self.artwork_view, AudioPlayer.current_item, :medium)
  end

end