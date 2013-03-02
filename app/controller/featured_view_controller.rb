class FeaturedViewController < UITableViewController
  extend IB
  include TracksViewController

  attr_accessor :featured, :latest, :random

  def reloadData
    @featured ||= []
    @latest ||= []
    @random ||= []
    self.tableView.reloadData
  end

  def sections
    [self.featured,self.latest,self.random]
  end

  def viewWillAppear(animated)
    super
    reloadData
    App.api.get_featured_tracks -> results {
      loaded_tracks results, :featured
    }
    App.api.get_latest_tracks -> results {
      loaded_tracks results, :latest
    }
    App.api.get_random_tracks -> results {
      loaded_tracks results, :random
    }
  end

  def loaded_tracks(results, attribute)
    if results.is_a? NSArray
      self.send("#{attribute}=", results)
      reloadData
    end
  end

  def track_for_index_path(indexPath)
    self.sections[indexPath.section][indexPath.row]
  end

  def tracks_for_queue_at_index_path(indexPath)
    self.sections[indexPath.section]
  end

  # Table View Delegate

  def numberOfSectionsInTableView(tableView)
    return 3
  end

  def tableView(tableView, numberOfRowsInSection: section)
    self.sections[section].count
  end

  def tableView(tableView, titleForHeaderInSection: section)
    ["Featured","Latest","Some Random Tracks"][section]
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    super
    AudioPlayer.queue_position = 1 + indexPath.row
    AudioPlayer.play
  end

end