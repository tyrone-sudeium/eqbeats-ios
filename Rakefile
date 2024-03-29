# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler'
Bundler.require
require 'bubble-wrap'
require 'bubble-wrap/reactor'
require 'ib'
require 'motion-cocoapods'
require 'motion-testflight'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'eqbeats-ios'
  app.identifier = 'com.sudeium.eqbeats'
  app.version = '0.0.1'
  app.short_version = '0.0.1'
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
  app.device_family = [:iphone]
  app.deployment_target = '6.0'
  app.prerendered_icon = true
  app.info_plist['CFBundleDisplayName'] = 'EqBeats'
  app.pods do
    pod 'RestKit', '~>0.10.3'
    pod 'SDWebImage', '>= 3.0'
    pod 'MarqueeLabel', :podspec => 'scripts/podspec/MarqueeLabel.podspec'
    pod 'TestFlightSDK'
  end
  app.vendor_project('vendor/libeqbeats', :xcode)
  app.background_modes = [:audio]

  app.development do
    app.entitlements['get-task-allow'] = true
    app.unvendor_project('vendor/libeqbeats')
    app.vendor_project('vendor/libeqbeats', :xcode, configuration: 'debug')
  end

  app.provisioning_profile = 'data/EqBeats_AdHoc_TestFlight.mobileprovision'
  app.codesign_certificate = 'iPhone Distribution: Sudeium Development'
end

namespace 'eqbeats' do
  task :setup_testflight do
    load 'testflight_setup.rb'
  end
end

task 'testflight:submit' => 'eqbeats:setup_testflight'

task :vendor_clean_run do
  Motion::Project::App.config.vendor_projects.each { |vendor| vendor.clean }
  ENV['retina'] = '4'
  Rake::Task["simulator"].invoke
end
