# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RestSoapWebServices' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for RestSoapWebServices
    pod 'AFNetworking', '~> 3.0'

    pod 'libObjCAttr'
    
    pod 'LinqToObjectiveC', '~> 2.1'

    post_install do |installer|
    require File.expand_path('ROADConfigurator.rb', './Pods/libObjCAttr/libObjCAttr/Resources/')
    ROADConfigurator::post_install(installer)
    end
end
