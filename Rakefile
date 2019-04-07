task default: %w[help]

class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def bold;           "\e[1m#{self}\e[22m" end
end

task :help do
    sh("rake -T")
end

desc "Install dependencies"
task :deps do
    sh("carthage update --platform iOS")
end

desc "Generate logo"
rake :logo do
    sh("appicon install logo.png ./WeatherMe/Resources/Assets.xcassets/")
end

desc "Add badge alpha"
rake :alpha do
    sh("badge --dark --alpha")
end

desc "Sync folder archi"
task : do
    sh("synx WeatherMe.xcodeproj")
end

desc "Clean project (xcodebuild + derived data)"
task :clean do
    `xcodebuild clean`
    sh('while [ -n "$(ls ~/Library/Developer/Xcode/DerivedData)" ]; do rm -rf ~/Library/Developer/Xcode/DerivedData 2> /dev/null;done')
end

desc "Open project"
task :open do
    `open WeatherMe.xcodeproj`
end

desc "kill Xcode"
task :kill do
    `killall Xcode`
end

