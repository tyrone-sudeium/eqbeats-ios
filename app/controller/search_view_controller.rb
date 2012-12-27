class SearchViewController < UITableViewController
  extend IB

  attr_accessor :search_results

  def viewDidLoad
    super
  end

  def viewWillAppear(animated)
    super
    @@track_cell_nib ||= UINib.nibWithNibName('TrackCell', bundle: NSBundle.mainBundle)
    self.tableView.registerNib(@@track_cell_nib, forCellReuseIdentifier:'TrackCell')
    #self.searchBar.text_field.font = Theme.normal_font_at_size(13)
    reloadData
  end

  def viewDidAppear(animated)
    super
  end

  def reloadData
    @search_results ||= []
    self.tableView.reloadData
    searchTableView.reloadData
  end

  def searchDisplayController(controller, shouldReloadTableForSearchScope:searchOption)
    # Load new search
    performSearchDelayed
    false
  end

  def searchDisplayController(controller, shouldReloadTableForSearchString:searchString)
    performSearchDelayed
    false
  end

  def searchDisplayController(controller, willShowSearchResultsTableView:tableView)
    tableView.registerNib(@@track_cell_nib, forCellReuseIdentifier:'TrackCell')
  end

  def searchTableView
    self.searchDisplayController.searchResultsTableView
  end

  def searchBar
    self.searchDisplayController.searchBar
  end

  def performSearchDelayed
    NSObject.cancelPreviousPerformRequestsWithTarget(self, 'performSearch', object:nil)
    self.performSelector('performSearch', withObject:nil, afterDelay:0.75)
  end

  def performSearch
    @search_results = []
    reloadData
    case searchBar.selectedScopeButtonIndex
    when 0
      App.delegate.api.search_track "#{searchBar.text}", -> results {
        if results.is_a? NSArray
          @search_results = results
          reloadData
        end
      }
    end
  end

  # Table View Delegate

  def tableView(tableView, numberOfRowsInSection: section)
    return @search_results.count
  end

  def numberOfSectionsInTableView(tableView)
    return 1
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('TrackCell')
    track = @search_results[indexPath.row]
    # Theming
    cell.titleLabel.font = Theme.adjust_font_face(cell.titleLabel.font)
    cell.detailTitleLabel.font = Theme.adjust_font_face(cell.detailTitleLabel.font)

    cell.titleLabel.text = track.title
    cell.detailTitleLabel.text = track.artist.name
    cell.artworkView.setImageWithURL(NSURL.URLWithString(track.art_link(:thumb)))
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    track = @search_results[indexPath.row]
    AudioPlayer.playback_queue = [track]
    AudioPlayer.play
  end

end
