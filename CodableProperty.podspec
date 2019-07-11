Pod::Spec.new do |s|
  s.name             = 'CodableProperty'
  s.version          = '0.1.0'
  s.summary          = 'Easy transforming of Codable types written in Swift'

  s.description      = <<-DESC
  CodableProperty is a framework written in Swift that works along with the build in `Codable` protocol.
  Uses the new `propertyWrapper` feature of Swift 5.1 to make type transformation easier.
                       DESC

  s.homepage         = 'https://github.com/gcharita/CodableProperty'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gcharita' => 'chgiorgos13@gmail.com' }
  s.source           = { :git => 'https://github.com/gcharita/CodableProperty.git', :tag => s.version.to_s }

  s.watchos.deployment_target = '2.0'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'CodableProperty/Classes/**/*'
  
  s.swift_version = '4.2'
end
