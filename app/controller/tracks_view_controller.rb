# Mixin for any table view that shows a list of EQBeats tracks.
module TracksViewController

  def viewWillAppear(animated)
    super
    @@track_cell_nib ||= UINib.nibWithNibName('TrackCell', bundle: NSBundle.mainBundle)
    self.tableView.registerNib(@@track_cell_nib, forCellReuseIdentifier:'TrackCell')
  end

  # override this
  def track_for_index_path(indexPath)
    nil
  end

  # override this too!
  def tracks_for_queue_at_index_path(indexPath)
    [self.track_for_index_path(indexPath)]
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    track_cell_for_index_path indexPath
  end

  def track_cell_for_index_path(indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('TrackCell')
    track = track_for_index_path indexPath
    # Theming
    cell.titleLabel.font = Theme.adjust_font_face(cell.titleLabel.font)
    cell.detailTitleLabel.font = Theme.adjust_font_face(cell.detailTitleLabel.font)
    if cell.backgroundView.nil?
      cell.backgroundView = UIView.alloc.initWithFrame(cell.bounds)
    end

    if indexPath.row % 2 == 0
      cell.backgroundView.setBackgroundColor('#FCF6FD'.to_color)
    else
      cell.backgroundView.setBackgroundColor('white'.to_color)
    end

    cell.titleLabel.text = track.title
    cell.detailTitleLabel.text = track.artist.name
    ResourcesController.set_image_view_for_track cell.artworkView, track, :thumb
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    AudioPlayer.playback_queue = self.tracks_for_queue_at_index_path indexPath
    player = self.storyboard.instantiateViewControllerWithIdentifier('NowPlaying')
    App.delegate.navigation_controller.pushViewController(player, animated:true)
  end

  def self.track_cell_nib
    @@track_cell_nib
  end

end
