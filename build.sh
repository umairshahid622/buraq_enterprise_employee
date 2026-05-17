#!/bin/bash

# Read current version from pubspec.yaml
CURRENT_VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | cut -d'+' -f1)

# Read current build number and increment
CURRENT_BUILD=$(grep "^version:" pubspec.yaml | cut -d'+' -f2)
NEW_BUILD=$((CURRENT_BUILD + 1))

# Ask for new version name
echo "Current version: $CURRENT_VERSION+$CURRENT_BUILD"
read -p "Enter new version (press enter to keep $CURRENT_VERSION): " NEW_VERSION

# Use current version if nothing entered
if [ -z "$NEW_VERSION" ]; then
  NEW_VERSION=$CURRENT_VERSION
fi

# Update pubspec.yaml automatically
sed -i "s/^version: .*/version: $NEW_VERSION+$NEW_BUILD/" pubspec.yaml

echo "Building $NEW_VERSION+$NEW_BUILD..."

# Build APK
flutter build apk --release

echo "✅ Done — version: $NEW_VERSION+$NEW_BUILD"
echo "📝 Don't forget to update Firestore currentVersion to: $NEW_VERSION"