#!/bin/bash
adb uninstall tm.com.sanlyteklip.eagle
flutter build apk --split-per-abi
adb install -r $(pwd)/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
open $(pwd)/build/app/outputs/flutter-apk/