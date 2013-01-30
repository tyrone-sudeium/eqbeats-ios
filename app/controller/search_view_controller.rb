class SearchViewController < UITableViewController
  extend IB
  include TracksViewController

  attr_accessor :search_results

  def viewDidLoad
    super
  end

  def viewWillAppear(animated)
    super
    @@user_cell_nib ||= UINib.nibWithNibName('UserCell', bundle: NSBundle.mainBundle)
    self.tableView.registerNib(@@user_cell_nib, forCellReuseIdentifier:'UserCell')
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
    tableView.registerNib(TracksViewController.track_cell_nib, forCellReuseIdentifier:'TrackCell')
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
    return if searchBar.text.length < 3
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
    when 1
      App.delegate.api.search_user "#{searchBar.text}", -> results {
        if results.is_a? NSArray
          @search_results = results
          reloadData
        end
      }
    end
  end

  def track_for_index_path(indexPath)
    @search_results[indexPath.row]
  end

  def tracks_for_queue_at_index_path(indexPath)
    @search_results
  end

  # Table View Delegate

  def tableView(tableView, numberOfRowsInSection: section)
    return @search_results.count
  end

  def numberOfSectionsInTableView(tableView)
    return 1
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    #return unless tableView == self.searchTableView
    case searchBar.selectedScopeButtonIndex
    when 0
      # Track Search
      return self.track_cell_for_index_path indexPath
    when 1
      # User Search
      return self.user_cell_for_row indexPath.row
    end
  end

  def user_cell_for_row(row)
    cell = tableView.dequeueReusableCellWithIdentifier('UserCell')
    user = @search_results[row]
    # Theming
    cell.name_label.font = Theme.adjust_font_face(cell.name_label.font)
    cell.description_label.font = Theme.adjust_font_face(cell.description_label.font)

    cell.name_label.text = user.name
    cell.description_label.text = user.plain_detail
    cell.image_view.setImageWithURL(NSURL.URLWithString(user.avatar))
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    super
    AudioPlayer.queue_position = 1 + indexPath.row
    AudioPlayer.play
  end

end
