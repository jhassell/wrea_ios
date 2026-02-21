# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'wrealeg' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  source 'https://github.com/CocoaPods/Specs.git'

  # Pods for sd2014leg
  pod 'Realm'
  pod 'SSZipArchive'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
    if target.name == 'Realm'
      target.shell_script_build_phases.each do |phase|
        if phase.name == 'Create Symlinks to Header Folders'
          phase.always_out_of_date = '1'
        end
      end
    end
  end
end
