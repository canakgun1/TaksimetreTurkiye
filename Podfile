# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Taksimetre+' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Taksimetre+
pod 'Google-Mobile-Ads-SDK'
pod 'FirebaseAnalytics'
pod 'FirebaseFirestore'
pod 'FirebaseAuth'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end

end
