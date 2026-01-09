# Firebase Setup Guide for Thozhi

This guide will help you set up Firebase for the Thozhi app.

## Prerequisites

1. A Google account
2. Access to Firebase Console (https://console.firebase.google.com/)

## Step-by-Step Setup

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: `thozhi` (or your preferred name)
4. Enable Google Analytics (optional but recommended)
5. Click "Create project"
6. Wait for project creation to complete

### 2. Register Your App

#### For Android:

1. In Firebase Console, click on Android icon
2. Enter package name: `com.example.thozhi` (or your package name)
3. Enter app nickname: `Thozhi Android`
4. Enter SHA-1 (optional for now, required for OTP)
5. Click "Register app"
6. Download `google-services.json`
7. Place it in `android/app/` directory

#### For iOS:

1. In Firebase Console, click on iOS icon
2. Enter bundle ID: `com.example.thozhi` (or your bundle ID)
3. Enter app nickname: `Thozhi iOS`
4. Enter App Store ID (optional)
5. Click "Register app"
6. Download `GoogleService-Info.plist`
7. Place it in `ios/Runner/` directory

### 3. Configure Android

1. Update `android/build.gradle`:
   ```gradle
   buildscript {
       repositories {
           // ... existing code
           google()
           mavenCentral()
       }
       dependencies {
           // ... existing code
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

2. Update `android/app/build.gradle`:
   ```gradle
   // At the bottom of the file
   apply plugin: 'com.google.gms.google-services'
   ```

3. Update `android/app/build.gradle` dependencies:
   ```gradle
   dependencies {
       // ... existing code
       implementation platform('com.google.firebase:firebase-bom:32.7.0')
   }
   ```

### 4. Configure iOS

1. Open `ios/Runner.xcworkspace` in Xcode (not .xcodeproj)
2. Ensure `GoogleService-Info.plist` is added to the project
3. Update `ios/Podfile`:
   ```ruby
   platform :ios, '12.0'
   ```
4. Run:
   ```bash
   cd ios
   pod install
   cd ..
   ```

### 5. Enable Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable the following sign-in methods:
   - **Email/Password**: Enable
   - **Phone**: Enable (for OTP)

### 6. Create Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in production mode" (we'll add rules later)
4. Select a location (choose closest to your users)
5. Click "Enable"

### 7. Set Firestore Security Rules

1. Go to Firestore Database → Rules
2. Replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Daily logs collection
    match /daily_logs/{logId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
    
    // Burnout assessments collection
    match /burnout_assessments/{assessmentId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
  }
}
```

3. Click "Publish"

### 8. Enable Cloud Messaging (Optional for MVP)

1. Cloud Messaging is automatically enabled
2. For production, you may need to:
   - Set up APNs (iOS)
   - Configure Android notification channels

### 9. Generate Firebase Options (Recommended)

Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Configure Firebase:

```bash
flutterfire configure
```

This will:
- Auto-detect your Firebase project
- Generate `lib/firebase_options.dart`
- Update your configuration files

### 10. Manual Firebase Options (Alternative)

If you prefer manual setup, create `lib/core/config/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'com.example.thozhi',
  );
}
```

Find these values in:
- Firebase Console → Project Settings → Your apps
- Or in `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)

### 11. Update app.dart

Update `lib/app.dart` to use Firebase options:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'core/config/firebase_options.dart'; // If manual setup

// In _initializeApp:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

If using FlutterFire CLI, it auto-generates and configures this.

### 12. Test Firebase Connection

1. Run the app:
   ```bash
   flutter run
   ```

2. Check console for any Firebase errors

3. Test authentication:
   - Try signing up with email
   - Check Firebase Console → Authentication → Users

4. Test Firestore:
   - Complete user profile
   - Check Firebase Console → Firestore Database

## Troubleshooting

### Android Issues

**"google-services.json not found"**
- Ensure file is in `android/app/` directory
- File name must be exactly `google-services.json`

**"Class not found"**
- Run `flutter clean`
- Delete `.flutter-plugins` and `.flutter-plugins-dependencies`
- Run `flutter pub get`
- Rebuild: `flutter run`

### iOS Issues

**"GoogleService-Info.plist not found"**
- Ensure file is in `ios/Runner/` directory
- In Xcode, ensure file is added to Runner target

**Pod install errors**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

### Authentication Issues

**Email/Password not working**
- Check Authentication is enabled in Firebase Console
- Verify email format
- Check Firebase Console → Authentication → Users

**OTP/Phone auth not working**
- SHA-1 fingerprint required for Android
  ```bash
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```
- Add SHA-1 to Firebase Console → Project Settings → Your Android app

## Security Notes

- Never commit `google-services.json` or `GoogleService-Info.plist` with real credentials to public repos
- Use environment-specific Firebase projects for dev/staging/prod
- Regularly review Firestore security rules
- Monitor Firebase Console for unusual activity

## Next Steps

- Set up Firebase Analytics (optional)
- Configure Cloud Functions (optional, for server-side logic)
- Set up Firebase Storage (if needed for images)
- Configure custom domains (production)

---

For more help, visit [Firebase Documentation](https://firebase.google.com/docs)
