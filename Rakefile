# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

# require 'bundler'
# Bundler.require
require 'bubble-wrap'
require 'bubble-wrap/reactor'
# require 'sugarcube'
require 'ib'
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
    'QuartzCore',
    'AVFoundation'
  ]

  app.pods do
    #pod 'BlocksKit'
    pod 'RestKit', '~>0.10.3'
    pod 'SDWebImage', '>= 3.0'
  end
end
