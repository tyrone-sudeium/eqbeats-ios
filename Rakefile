# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

# require 'bundler'
# Bundler.require
# require 'bubble-wrap'
# require 'sugarcube'
# require 'ib'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'eqbeats'
  app.identifier = 'com.sudeium.eqbeats'
  app.frameworks += [
    'CFNetwork',
    'SystemConfiguration',
    'MobileCoreServices',
    'Security',
    'QuartzCore'
  ]

  app.pods do
    pod 'BlocksKit'
    pod 'RestKit', '~>0.10.3'
  end
end
