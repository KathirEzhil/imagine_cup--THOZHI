# Firebase Configuration Placeholder

## ⚠️ Important: Firebase Setup Required

For the app to run with full functionality, you need to set up Firebase. However, the app will still run and display all screens even without Firebase (authentication and data storage won't work).

## Quick Setup Steps

1. **Install FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Configure Firebase**:
   ```bash
   flutterfire configure
   ```
   
   This will:
   - Detect your Firebase project
   - Generate `lib/firebase_options.dart`
   - Update configuration files automatically

3. **Enable Firebase Services**:
   - Go to Firebase Console: https://console.firebase.google.com/
   - Enable Authentication (Email/Password and Phone)
   - Create Firestore Database
   - Copy security rules from `SETUP_FIREBASE.md`

## For Demo/Testing Without Firebase

The app is designed to gracefully handle missing Firebase configuration:
- All screens will display
- UI will work
- Navigation will function
- Authentication/data storage will show errors (which is expected)

## Files You Need to Add

After running `flutterfire configure`, these files will be created/updated:

### Android
- `android/app/google-services.json` (automatically added by flutterfire configure)

### iOS  
- `ios/Runner/GoogleService-Info.plist` (automatically added by flutterfire configure)

### Generated Code
- `lib/firebase_options.dart` (automatically generated)

## Manual Setup Alternative

If you prefer manual setup, see `SETUP_FIREBASE.md` for detailed instructions.

---

**Note**: For hackathon demo, you can show the app without Firebase setup to demonstrate UI/UX. For full functionality demo, Firebase setup is recommended.
