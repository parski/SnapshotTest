Pod::Spec.new do |s|
  s.name         = "SnapshotTest"
  s.version      = "0.1"
  s.summary      = "Snapshot testing tool for iOS and tvOS"
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = "https://github.com/parski/SnapshotTest"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Pär Strindevall" => "par@strindevall.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/parski/SnapshotTest.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation", "XCTest"
end
