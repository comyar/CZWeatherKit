Pod::Spec.new do |s|
    s.name          = 'CZWeatherKit'
    s.version       = '0.1'
    s.summary       = 'An easy-to-use Cocoa weather library.'
    spec.license    =  :type => 'BSD' 
    s.author        = {
        'Comyar Zaheri' => 'comyarzaheri@utexas.edu'
    }
    s.source        = {
        :git => 'https://github.com/CZWeatherKit/CZWeatherKit.git',
        :tag => s.version.to_s
    }
    s.source_files  = 'CZWeatherKit/*.{h,m}'
end