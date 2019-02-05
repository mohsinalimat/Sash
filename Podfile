use_frameworks!
project 'PTR.xcodeproj'

def my_pods

    pod 'DifferenceKit', '~> 0.5'
    pod 'GenericDataSources'
    pod 'FSCalendar'
    pod 'BEMCheckBox'
    pod 'DZNEmptyDataSet'
    pod 'DeckTransition', '~> 2.0'
    pod 'ValueStepper'
    pod 'EMPageViewController'
    pod 'GSKStretchyHeaderView'
    pod 'ViewAnimator'
    pod 'MaterialShowcase'
    pod 'AYGestureHelpView'
    pod 'AlgoliaSearch-Client-Swift', '~> 4.8.1'
end


target 'PTR' do
    my_pods
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end







#end
