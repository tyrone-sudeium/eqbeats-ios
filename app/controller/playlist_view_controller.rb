class PlaylistViewController < UITableViewController
  extend IB
  include TracksViewController

  attr_accessor :playlist
  outlet :titleTextField, UITextField

  def viewDidLoad
    super
    titleTextField.text = playlist.name
  end

  def optionsCell
    @optionsCell ||= begin
      cell = self.tableView.dequeueReusableCellWithIdentifier('PlaylistOptionsCell')
      cell.editButton.addTarget(self, 
                                action:'editButtonAction:', 
                                forControlEvents: UIControlEventTouchUpInside)
      cell.clearButton.addTarget(self, 
                                 action:'clearButtonAction:', 
                                 forControlEvents: UIControlEventTouchUpInside)
      cell.deleteButton.addTarget(self, 
                                  action:'deleteButtonAction:', 
                                  forControlEvents: UIControlEventTouchUpInside)
      cell
    end
    @optionsCell
  end

  def track_for_index_path(indexPath)
    playlist.tracks[indexPath.row-1]
  end

  def tracks_for_queue_at_index_path(indexPath)
    playlist.tracks
  end

  # Table View
  def tableView(tableView, numberOfRowsInSection: section)
    playlist.tracks.count + 1
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    if indexPath.row == 0
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      return
    end

    super
    AudioPlayer.queue_position = indexPath.row
    AudioPlayer.play
  end

  # Actions
  def editButtonAction(sender)

  end

  def clearButtonAction(sender)

  end

  def deleteButtonAction(sender)

  end

end
