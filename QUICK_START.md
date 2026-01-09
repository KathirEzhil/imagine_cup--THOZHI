# Thozhi - Quick Start Guide

## 🚀 Quick Setup (5 minutes)

### Prerequisites
- Flutter SDK 3.0.0+ installed
- Android Studio / VS Code with Flutter extensions
- Firebase account (free tier is fine)

### Steps

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase (Required)**
   
   Option A: Using FlutterFire CLI (Recommended)
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Follow the prompts to select your Firebase project and platforms.

   Option B: Manual setup
   - Follow `SETUP_FIREBASE.md` for detailed instructions
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the correct directories
   - Create `lib/core/config/firebase_options.dart` (see `SETUP_FIREBASE.md`)

3. **Enable Firebase Services**
   
   In Firebase Console:
   - Go to Authentication → Enable Email/Password and Phone
   - Go to Firestore Database → Create database (production mode)
   - Copy security rules from `SETUP_FIREBASE.md`

4. **Run the app**
   ```bash
   flutter run
   ```

### Test Account (For Demo)

For quick testing without full Firebase setup:
- The app will still run but authentication won't work
- You can explore the UI and screens
- Complete Firebase setup is required for full functionality

## 📱 Testing the App

1. **First Launch**
   - App shows splash screen
   - Onboarding screens appear
   - Consent screen
   - Login/Sign up screen

2. **Create Account**
   - Use email/password or phone number
   - Complete profile questionnaire
   - Dashboard appears

3. **Daily Check-In**
   - Complete daily check-in form (< 1 minute)
   - View wellness score
   - Check burnout prediction

4. **Explore Features**
   - Dashboard → Home screen with quick actions
   - Insights → Wellness score and trends
   - Interventions → Personalized recommendations
   - Emotional Support → Affirmations and journaling
   - Personal Time → Me-time tracking
   - Alerts → Notifications and preferences

## 🔧 Troubleshooting

**"Firebase not initialized" error:**
- Ensure you've run `flutterfire configure` or manually set up Firebase
- Check that `google-services.json` / `GoogleService-Info.plist` are in correct locations

**Build errors:**
```bash
flutter clean
flutter pub get
flutter run
```

**Authentication not working:**
- Check Firebase Console → Authentication is enabled
- Verify Email/Password and Phone authentication are enabled
- Check Firebase security rules

**Firestore errors:**
- Ensure Firestore database is created
- Check security rules match the ones in `SETUP_FIREBASE.md`
- Verify collection names match `AppConstants`

## 📚 Next Steps

- Read full `README.md` for detailed documentation
- Check `SETUP_FIREBASE.md` for Firebase configuration details
- Review code comments for implementation details

## 🎯 MVP Features Checklist

- ✅ Splash & Onboarding
- ✅ Authentication (Email/Phone)
- ✅ User Profiling
- ✅ Dashboard
- ✅ Daily Check-In
- ✅ Burnout Prediction
- ✅ Insights & Trends
- ✅ Interventions
- ✅ Emotional Support
- ✅ Personal Time Tracker
- ✅ Alerts & Notifications
- ✅ Community/Blog
- ✅ Profile & Settings
- ✅ Help & Support

## 🚨 Important Notes

- **This is an MVP for hackathon demonstration**
- Firebase setup is **required** for full functionality
- The burnout prediction uses **rule-based logic** (ML-ready architecture)
- All data is stored in **Firestore** (ensure security rules are set)
- Notifications require **proper Firebase configuration**

---

**Need Help?** Check `SETUP_FIREBASE.md` or `README.md` for detailed guides.
