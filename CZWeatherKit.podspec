Pod::Spec.new do |s|
  s.name         = "CZWeatherKit"
  s.version      = "2.0.2"
  s.summary      = "A Simple Cocoa Weather Library."
  s.description  = <<-DESC
                   CZWeatherKit is a simple, extensible weather library for iOS and OS X 
                   that allows for easy downloading of weather data from various weather services.
                   DESC
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Comyar Zaheri" => "" }
  s.homepage     = "https://github.com/comyarzaheri/CZWeatherKit"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source       = { :git => "https://github.com/comyarzaheri/CZWeatherKit.git", :tag => s.version.to_s}
  s.source_files = 'CZWeatherKit/*.{h,m}', 'CZWeatherKit/**/*.{h,m}'
  s.module_name = 'CZWeatherKit'
  s.requires_arc = true
end
