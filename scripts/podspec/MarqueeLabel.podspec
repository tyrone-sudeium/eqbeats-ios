Pod::Spec.new do |s|
  s.name         = "MarqueeLabel"
  s.version      = "0.0.1"
  s.summary      = "Label which automatically adds a scrolling marquee effect when the label's text is larger than the specified frame."
  s.description  = <<-DESC
                    MarqueeLabel is a functional equivalent to UILabel that adds a scrolling marquee effect 
                    when the text of the label outgrows the available width. The label scrolling direction 
                    and speed/rate can be specified as well. All standard UILabel properties (where it makes 
                    sense) are available in MarqueeLabel and it behaves just like a UILabel.
                  DESC
  s.homepage     = "https://github.com/cbpowell/MarqueeLabel"
  s.license      = 'MIT'
  s.author       = "Charles Powell"
  s.source       = { :git => "https://github.com/tyrone-sudeium/MarqueeLabel.git", :commit => "592c58d69a0cef89f314ccf8229d7c486c85fb04" }
  s.platform     = :ios, '5.0'
  s.source_files = 'MarqueeLabel.h', 'MarqueeLabel.m'
  s.framework  = 'QuartzCore'
  s.requires_arc = true
end
