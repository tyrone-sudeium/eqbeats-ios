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
  app.name = 'eqbeats-ios'
  app.identifier = 'com.sudeium.eqbeats'
  app.version = "1.0.0"
  app.short_version = "1"
  app.interface_orientations = [:portrait]
  app.frameworks += [
    'CFNetwork',
    'SystemConfiguration',
    'MobileCoreServices',
    'Security',
    'QuartzCore',
    'AVFoundation',
    'MediaPlayer'
  ]
  app.device_family = [:iphone, :ipad]
  app.deployment_target = '6.0'
  app.prerendered_icon = true
  app.info_plist['CFBundleDisplayName'] = 'eqbeats'
  app.pods do
    #pod 'BlocksKit'
    pod 'RestKit', '~>0.10.3'
    pod 'SDWebImage', '>= 3.0'
    pod 'MarqueeLabel', :podspec => 'scripts/podspec/MarqueeLabel.podspec'
  end
  app.background_modes = [:audio]
end
