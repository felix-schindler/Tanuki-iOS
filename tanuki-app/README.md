# Tanuki

This is a [Skip](https://skip.dev) app: one Swift codebase that builds the native
iOS app and the transpiled Android app.


<!-- TODO: add iOS screenshots to fastlane metadata
## iPhone Screenshots

<img alt="iPhone Screenshot" src="Darwin/fastlane/screenshots/en-US/1_en-US.png" style="width: 18%" /> <img alt="iPhone Screenshot" src="Darwin/fastlane/screenshots/en-US/2_en-US.png" style="width: 18%" /> <img alt="iPhone Screenshot" src="Darwin/fastlane/screenshots/en-US/3_en-US.png" style="width: 18%" /> <img alt="iPhone Screenshot" src="Darwin/fastlane/screenshots/en-US/4_en-US.png" style="width: 18%" /> <img alt="iPhone Screenshot" src="Darwin/fastlane/screenshots/en-US/5_en-US.png" style="width: 18%" />
-->

<!-- TODO: add Android screenshots to fastlane metadata
## Android Screenshots

<img alt="Android Screenshot" src="Android/fastlane/metadata/android/en-US/images/phoneScreenshots/1_en-US.png" style="width: 18%" /> <img alt="Android Screenshot" src="Android/fastlane/metadata/android/en-US/images/phoneScreenshots/2_en-US.png" style="width: 18%" /> <img alt="Android Screenshot" src="Android/fastlane/metadata/android/en-US/images/phoneScreenshots/3_en-US.png" style="width: 18%" /> <img alt="Android Screenshot" src="Android/fastlane/metadata/android/en-US/images/phoneScreenshots/4_en-US.png" style="width: 18%" /> <img alt="Android Screenshot" src="Android/fastlane/metadata/android/en-US/images/phoneScreenshots/5_en-US.png" style="width: 18%" />
-->

## Building

This project is both a stand-alone Swift Package Manager module,
as well as an Xcode project that builds and translates the project
into a Kotlin Gradle project for Android using the skipstone plugin.

## Running

Open `Project.xcworkspace` in Xcode and run the "Tanuki App" target in the iOS
Simulator.

For Android, run `skip app launch --android` from this directory with a physical
device connected over ADB. Do not use the Android emulator: the Android app is
built, installed and verified on the device (`scripts/android-debug.sh` at the
repo root reads the app log, dumps crashes and demangles symbols).

## Testing

There is no test target. Verify changes with `make check` from the repo root,
plus a run on the iOS Simulator and the Android device. `swift test` and
`swift build` are not usable here — SwiftPM's build of the Skip product graph is
broken upstream (see `AGENTS.md`, "Known issues").
