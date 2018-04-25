#!/bin/bash

# Exit the script if any statement returns a non-true return value
set -e

## Build and test
set -o pipefail && xcodebuild -project "SnapshotTest.xcodeproj" -scheme "SnapshotTest-iOS" -configuration "Debug" -sdk "iphonesimulator" -destination "name=iPhone 7" clean test | bundle exec xcpretty
set -o pipefail && xcodebuild -project "SnapshotTest.xcodeproj" -scheme "SnapshotTest-tvOS" -configuration "Debug" -sdk "appletvsimulator" -destination "name=Apple TV" clean test | bundle exec xcpretty


# Dependency manager integration test

## CocoaPods
pushd Integration/CocoaPods/
bundle exec pod install
set -o pipefail && xcodebuild -workspace "CocoaPods.xcworkspace" -scheme "CocoaPods" -configuration "Debug" -sdk "iphonesimulator" -destination "name=iPhone 7" clean test | bundle exec xcpretty
popd