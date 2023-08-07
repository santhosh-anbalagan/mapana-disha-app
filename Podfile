# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'mapana' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mapana
    pod 'DropDown' , '2.3.2'
    pod 'SDWebImage' , '~> 5.0'
    pod 'Polyline', '~> 5.0'
    pod 'lottie-ios'

    #pod 'FLEX', :configurations => ['Debug']


post_install do |installer|
  installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
             end
        end
 end
end

end


