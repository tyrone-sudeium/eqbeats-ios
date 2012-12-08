class SearchViewController < UITableViewController
  extend IB

  attr_accessor :search_results

  def viewWillAppear(animated)
    super
    @@track_cell_nib ||= UINib.nibWithNibName('TrackCell', bundle: NSBundle.mainBundle)
    self.tableView.registerNib(@@track_cell_nib, forCellReuseIdentifier:'TrackCell')
    reloadData
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
      p 'performing search'
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
    cell.titleLabel.text = track.title
    cell.detailTitleLabel.text = track.artist.name
    cell
  end

end
