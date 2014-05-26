Pod::Spec.new do |s|
<<<<<<< HEAD
    s.name          = 'CZWeatherKit'
    s.version       = '0.1'
    s.summary       = 'An easy-to-use Cocoa weather library.'
    s.homepage   = 'https://www.comyar.io/czweatherkit'
    s.license    =  :type => 'BSD' 
    s.author        = {
        'Comyar Zaheri' => 'comyarzaheri@utexas.edu'
    }
    s.source        = {
        :git => 'https://github.com/CZWeatherKit/CZWeatherKit.git',
        :tag => s.version.to_s
    }
    s.source_files  = 'CZWeatherKit/*.{h,m}'
    s.requires_arc     = true
end
