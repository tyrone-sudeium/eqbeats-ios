class SearchViewController < UITableViewController
  extend IB

  attr_accessor :search_results

  def viewDidLoad
    super
  end

  def viewWillAppear(animated)
    super
    @@track_cell_nib ||= UINib.nibWithNibName('TrackCell', bundle: NSBundle.mainBundle)
    @@user_cell_nib ||= UINib.nibWithNibName('UserCell', bundle: NSBundle.mainBundle)
    self.tableView.registerNib(@@track_cell_nib, forCellReuseIdentifier:'TrackCell')
    self.tableView.registerNib(@@user_cell_nib, forCellReuseIdentifier:'UserCell')
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
    @search_results = []
    reloadData
    performSearchDelayed
    false
  end

  def searchDisplayController(controller, shouldReloadTableForSearchString:searchString)
    performSearchDelayed
    false
  end

  def searchDisplayController(controller, willShowSearchResultsTableView:tableView)
    tableView.registerNib(@@track_cell_nib, forCellReuseIdentifier:'TrackCell')
    tableView.registerNib(@@user_cell_nib, forCellReuseIdentifier:'UserCell')
  end

  def searchDisplayControllerDidEndSearch(controller)
    @search_results = []
    reloadData
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
    return unless tableView == self.searchTableView
    case searchBar.selectedScopeButtonIndex
    when 0
      # Track Search
      track_cell_for_row indexPath.row
    when 1
      # User Search
      user_cell_for_row indexPath.row
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    track = @search_results[indexPath.row]
    AudioPlayer.playback_queue = [track]
    AudioPlayer.play
    player = self.storyboard.instantiateViewControllerWithIdentifier('NowPlaying')
    App.delegate.navigation_controller.pushViewController(player, animated:true)
  end

  def track_cell_for_row(row)
    cell = tableView.dequeueReusableCellWithIdentifier('TrackCell')
    track = @search_results[row]
    # Theming
    cell.titleLabel.font = Theme.adjust_font_face(cell.titleLabel.font)
    cell.detailTitleLabel.font = Theme.adjust_font_face(cell.detailTitleLabel.font)

    cell.titleLabel.text = track.title
    cell.detailTitleLabel.text = track.artist.name
    cell.artworkView.setImageWithURL(NSURL.URLWithString(track.art_link(:thumb)))
    cell
  end

  def user_cell_for_row(row)
    cell = tableView.dequeueReusableCellWithIdentifier('UserCell')
    user = @search_results[row]
    # Theming
    cell.name_label.font = Theme.adjust_font_face(cell.name_label.font)
    cell.description_label.font = Theme.adjust_font_face(cell.description_label.font)

    cell.name_label.text = user.name
    cell.description_label.text = user.plain_detail
    cell
  end

end
