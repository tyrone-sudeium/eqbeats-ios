class RadioListViewController < UITableViewController
  extend IB

  def tableView(tableView, numberOfRowsInSection: section)
    return RadioStation.stations.count
  end

  def numberOfSectionsInTableView(tableView)
    return 1
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    UIImage.imageNamed(stationForRow(indexPath.row).icon_name).size.height
  end

  def stationForRow(row)
    stations = RadioStation.stations
    station = stations[row]
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('RadioCell')
    station = stationForRow(indexPath.row)
    cell.imageView.image = UIImage.imageNamed station.icon_name
    cell
  end

end