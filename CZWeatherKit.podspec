Pod::Spec.new do |s|
  s.name         = "CZWeatherKit"
  s.version      = "0.9.0"
  s.summary      = "A Simple Cocoa Weather Library."
  s.description  = <<-DESC
                   CZWeatherKit is a simple, extensible weather library for iOS and OS X 
                   that allows for easy downloading of weather data from various weather services.
                   DESC
  s.homepage     = "http://www.comyar.io/projects/czweatherkit"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  s.author       = { "Comyar Zaheri" => "comyarzaheri@utexas.edu" }
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/CZWeatherKit/CZWeatherKit.git", :tag => s.version.to_s}
  s.source_files = 'CZWeatherKit/*.{h,m}', 'CZWeatherKit/**/*.{h,m}'
  s.requires_arc = true
end
