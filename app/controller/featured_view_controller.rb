class FeaturedViewController < UITableViewController
  extend IB
  include TracksViewController

  outlet :segmentedControl, UISegmentedControl

  attr_accessor :featured, :latest, :random

  def viewDidLoad
    super
    self.refreshControl.addTarget(self, action:'refreshControlChanged:', forControlEvents: UIControlEventValueChanged)
  end

  def reloadData
    @featured ||= []
    @latest ||= []
    @random ||= []
    self.tableView.reloadData
  end

  def tracks
    [featured,latest,random][segmentedControl.selectedSegmentIndex]
  end

  def viewWillAppear(animated)
    super
    reloadData
    load_tracks(:featured)
    load_tracks(:latest)
    load_tracks(:random)
  end

  def load_tracks(symbol)
    App.api.send("get_#{symbol}_tracks") do |results|
      loaded_tracks results, symbol
    end
  end

  def loaded_tracks(results, attribute)
    if results.is_a? NSArray
      self.send("#{attribute}=", results)
      reloadData
    end
    self.refreshControl.endRefreshing if self.refreshControl.refreshing?
  end

  def track_for_index_path(indexPath)
    tracks[indexPath.row]
  end

  def tracks_for_queue_at_index_path(indexPath)
    tracks
  end

  # Table View Delegate

  def numberOfSectionsInTableView(tableView)
    return 1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    tracks.count
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    super
    AudioPlayer.queue_position = 1 + indexPath.row
    AudioPlayer.play
  end

  # Actions

  def segmentedControlChanged(sender)
    self.tableView.reloadData
  end

  def refreshControlChanged(sender)
    if sender.refreshing?
      # Begin reload
      load_tracks([:featured,:latest,:random][segmentedControl.selectedSegmentIndex])
    end
  end

end