# Thozhi - Wellness App for Homemakers

A Flutter mobile application designed to help homemakers predict burnout, track well-being, and receive personalized interventions using AI.

## 🎯 Project Overview

Thozhi is a wellness application built specifically for homemakers that:
- Predicts burnout risk levels (Low/Medium/High)
- Provides emotional support and validation
- Suggests personalized interventions
- Tracks personal time and emotional well-being
- Offers gentle, supportive alerts and reminders

## 🛠️ Tech Stack

### Frontend
- **Flutter** (latest stable version)
- **Material UI** with custom theme
- **Provider** for state management
- **fl_chart** for data visualization
- **google_fonts** for typography

### Backend / Cloud
- **Firebase Authentication** (Email/OTP)
- **Firebase Firestore** (NoSQL database)
- **Firebase Cloud Messaging** (Push notifications)
- **Firebase Storage** (Optional)

### Features
- Clean, modular architecture
- Rule-based burnout prediction (ML-ready)
- Offline-tolerant design
- Accessibility-first approach

## 📁 Project Structure

```
lib/
 ├── main.dart
 ├── app.dart
 ├── core/
 │    ├── theme/
 │    │    └── app_theme.dart
 │    ├── constants/
 │    │    └── app_constants.dart
 │    └── utils/
 │         ├── formatters.dart
 │         └── validators.dart
 ├── services/
 │    ├── auth_service.dart
 │    ├── firestore_service.dart
 │    └── notification_service.dart
 ├── models/
 │    ├── user_model.dart
 │    ├── daily_log_model.dart
 │    └── burnout_model.dart
 ├── providers/
 │    ├── user_provider.dart
 │    └── burnout_provider.dart
 ├── screens/
 │    ├── splash/
 │    ├── onboarding/
 │    ├── auth/
 │    ├── consent/
 │    ├── profiling/
 │    ├── dashboard/
 │    ├── daily_checkin/
 │    ├── insights/
 │    ├── interventions/
 │    ├── emotional_support/
 │    ├── personal_time/
 │    ├── community_blog/
 │    ├── alerts/
 │    ├── profile_settings/
 │    └── help_support/
 └── widgets/
      ├── app_logo.dart
      ├── burnout_indicator.dart
      ├── wellness_score_gauge.dart
      ├── gradient_button.dart
      └── quote_card.dart
```

## 🚀 Setup Instructions

### Prerequisites
1. **Flutter SDK** (3.0.0 or higher)
   ```bash
   flutter --version
   ```

2. **Firebase Account**
   - Create a project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Cloud Messaging

3. **Development Environment**
   - Android Studio / VS Code with Flutter extensions
   - Android SDK / Xcode (for iOS)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd thozhi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   a. **Android Setup:**
   - Go to Firebase Console → Project Settings
   - Download `google-services.json`
   - Place it in `android/app/`
   - Update `android/build.gradle`:
     ```gradle
     buildscript {
         dependencies {
             classpath 'com.google.gms:google-services:4.4.0'
         }
     }
     ```
   - Update `android/app/build.gradle`:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```

   b. **iOS Setup:**
   - Go to Firebase Console → Project Settings
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`
   - Open `ios/Runner.xcworkspace` in Xcode
   - Update `ios/Podfile`:
     ```ruby
     platform :ios, '12.0'
     ```
   - Run:
     ```bash
     cd ios && pod install && cd ..
     ```

4. **Firebase Configuration**

   Create a file `lib/core/config/firebase_options.dart`:
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

   **Alternative (Recommended):**
   Use Firebase CLI to auto-generate:
   ```bash
   npm install -g firebase-tools
   firebase login
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```

5. **Update app.dart**

   Modify `lib/app.dart` to use Firebase options:
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'core/config/firebase_options.dart';
   
   // In _initializeApp:
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

6. **Firebase Security Rules**

   Set up Firestore security rules in Firebase Console:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /daily_logs/{logId} {
         allow read, write: if request.auth != null && 
           resource.data.userId == request.auth.uid;
       }
       match /burnout_assessments/{assessmentId} {
         allow read, write: if request.auth != null && 
           resource.data.userId == request.auth.uid;
       }
       match /notifications/{notificationId} {
         allow read, write: if request.auth != null && 
           resource.data.userId == request.auth.uid;
       }
     }
   }
   ```

7. **Enable Firebase Services**

   In Firebase Console:
   - **Authentication**: Enable Email/Password and Phone authentication
   - **Firestore**: Create database in production mode
   - **Cloud Messaging**: No additional setup needed (works automatically)

8. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Features

### 1. **Splash & Onboarding**
   - Welcome screens
   - App introduction
   - Privacy & consent

### 2. **Authentication**
   - Email/Password login
   - Phone number OTP verification
   - Language selection (English/Tamil)

### 3. **User Profiling**
   - Conversational questionnaire
   - Physical & emotional health assessment
   - Profile completion tracking

### 4. **Dashboard**
   - Personalized greeting
   - Energy status
   - Burnout risk indicator
   - Quick actions
   - Daily check-in prompt

### 5. **Daily Check-In**
   - Stress level (0-10 slider)
   - Energy level selection
   - Mood (emoji selector)
   - Sleep hours
   - Physical activity minutes
   - Workload intensity
   - Optional notes

### 6. **Burnout Prediction**
   - Analyzes recent daily inputs
   - Calculates risk score
   - Provides level (Low/Medium/High)
   - Supportive explanation

### 7. **Insights & Trends**
   - Wellness score gauge
   - Weekly burnout trend graph
   - Stress & energy visualization
   - Today's snapshot

### 8. **Interventions**
   - Personalized recommendations
   - Rest activities
   - Exercise suggestions
   - Mindfulness tips
   - Help encouragement
   - Community support

### 9. **Emotional Support**
   - Daily affirmations
   - Validation messages
   - Optional journaling

### 10. **Personal Time Tracker**
   - Track me-time
   - Weekly progress view
   - Gentle reminders

### 11. **Alerts & Notifications**
   - Burnout alerts
   - Self-care nudges
   - Customizable preferences

### 12. **Community/Blog**
   - Mental health articles
   - Homemaker-focused content

### 13. **Profile & Settings**
   - Edit profile
   - Language preferences
   - Notification settings
   - Data export/delete
   - Logout

### 14. **Help & Support**
   - FAQs
   - Emergency resources
   - App disclaimer

## 🔐 Security & Privacy

- Firebase security rules enforce data access
- User data is encrypted in transit and at rest
- No ads or data selling
- Privacy-first design
- User can delete data anytime

## 🎨 Design Principles

- **Soft colors** only (no harsh alerts)
- **Friendly, validating tone** throughout
- **Large buttons and fonts** for accessibility
- **Minimal typing** required
- **Offline-tolerant** design
- **Empathetic UX** for homemakers

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Build

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

This is an MVP for a hackathon. For production use, consider:
- Adding unit and widget tests
- Implementing proper error handling
- Adding analytics
- Improving ML model integration
- Adding more languages
- Enhancing accessibility features

## 📄 License

[Add your license here]

## 🙏 Acknowledgments

Built with empathy for homemakers who deserve recognition, support, and care.

---

**Note**: This app is not a substitute for professional medical advice. Always consult healthcare professionals for medical concerns.
