Pod::Spec.new do |s|
  s.name = "SnapshotTest"
  s.version = "3.0.0"
  s.summary = "Snapshot testing tool for iOS and tvOS"
  s.description = "SnapshotTest is a simple view testing tool written completely in Swift to aid with development for Apple platforms. It's like unit testing for views."
  s.homepage = "https://github.com/parski/SnapshotTest"
  s.license = { :type => "2-clause BSD", :file => "LICENSE" }
  s.author = { "Pär Strindevall" => "par@strindevall.com", "André Stenvall" => "andre@stenvall.me" }
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.source = { :git => "https://github.com/parski/SnapshotTest.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"
  s.frameworks = "Foundation", "XCTest"
  s.swift_version = '5'
end
