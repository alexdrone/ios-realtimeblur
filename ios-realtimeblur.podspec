Pod::Spec.new do |s|
  s.name         = "ios-realtimeblur"
  s.version      = "1.0.0"
  s.summary      = "Real-time blur view, like in iOS 7"
  s.homepage     = "https://github.com/alexdrone/ios-realtimeblur"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { "Alex Usbergo" => "alexakadrone@gmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/alexdrone/ios-realtimeblur.git",
                     :tag => "#{s.version}" }
  s.source_files  = 'RealTimeBlur/Classes/*'
  s.frameworks = 'QuartzCore', 'Accelerate'
  s.requires_arc = true
end
