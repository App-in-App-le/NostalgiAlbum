# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NostalgiAlbum' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NostalgiAlbum
	pod 'RealmSwift'
	pod 'Zip', '~> 2.1'
	pod 'Mantis', '~> 2.8.0'
	pod 'ReachabilitySwift'
  target 'NostalgiAlbumTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NostalgiAlbumUITests' do
    # Pods for testing
  end

end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
     installer.pods_project.targets.each do |target|
          if target.name == 'Realm'
              create_symlink_phase = target.shell_script_build_phases.find { |x| x.name == 'Create Symlinks to Header Folders' }
              create_symlink_phase.always_out_of_date = "1"
          end
   end
end
  