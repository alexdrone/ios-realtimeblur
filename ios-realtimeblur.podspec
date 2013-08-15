Pod::Spec.new do |s|
  s.name         = "ios-realtimeblur"
  s.version      = "0.0.1"
  s.summary      = "Real-time blur view, like in iOS 7"
  s.description  = <<-DESC
                   A longer description of ios-realtimeblur in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  s.homepage     = "https://github.com/alexdrone/ios-realtimeblur"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
 # s.license      =  'MIT'
  s.author       = { "Alex Usbergo" => "alexakadrone@gmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/alexdrone/ios-realtimeblur.git", :commit => "80f1d36833b0b56ae02778a16cd7eda39492be31" }
  s.source_files  = 'RealTimeBlur/Classes/*'
  s.frameworks = 'QuartzCore', 'Accelerate'
  s.requires_arc = true
end
