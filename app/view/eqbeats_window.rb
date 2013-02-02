class EQBeatsWindow < UIWindow
  
  def canBecomeFirstResponder
    true
  end

  def remoteControlReceivedWithEvent(receivedEvent)
    case receivedEvent.subtype
    when UIEventSubtypeRemoteControlTogglePlayPause
      AudioPlayer.toggle_play_pause
    when UIEventSubtypeRemoteControlPlay
      AudioPlayer.play
    when UIEventSubtypeRemoteControlStop
      AudioPlayer.stop
    when UIEventSubtypeRemoteControlNextTrack
      AudioPlayer.next_track
    when UIEventSubtypeRemoteControlPreviousTrack
      AudioPlayer.previous_track
    end
  end

end