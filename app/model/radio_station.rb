class RadioStation
  attr_accessor :url, :name, :icon_name

  def initialize(url, name, icon_name)
    self.url = url
    self.name = name
    self.icon_name = icon_name
  end

  def self.stations
    @@stations ||= [
      RadioStation.new('http://molestia.ponify.me:8062', 
        'Celestia Radio', 'CelestiaRadio.png'),
      RadioStation.new('http://radio.everfreeradio.com:5800/listen.pls?sid=3',
        'Everfree Radio', 'EverfreeRadio.png'),
      RadioStation.new('http://67.159.45.87:8341',
        'BronyRadio', 'BronyRadio.png'),
      RadioStation.new('http://76.73.96.50:8071',
        'Everypony Radio', 'EveryponyRadio.png')
    ]
  end
end
