# Thozhi - Wellness App for Homemakers

<div align="center">

**A Flutter mobile application designed to help homemakers predict burnout, track well-being, and receive personalized interventions using AI.**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Firebase Setup](#-firebase-setup)
- [Running the App](#-running-the-app)
- [Building for Production](#-building-for-production)
- [Testing](#-testing)
- [Security & Privacy](#-security--privacy)
- [Design Principles](#-design-principles)
- [Contributing](#-contributing)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

---

## 🎯 Project Overview

**Thozhi** is a wellness application built specifically for homemakers that helps them:

- 🔍 **Predict burnout risk levels** (Low/Medium/High) using AI-powered analysis
- 💚 **Provide emotional support** and validation through daily interactions
- 🎯 **Suggest personalized interventions** based on individual needs
- 📊 **Track personal time** and emotional well-being over time
- 🔔 **Offer gentle, supportive alerts** and reminders for self-care

The app is designed with empathy and understanding, recognizing the unique challenges faced by homemakers and providing a safe, supportive space for wellness tracking.

---

## ✨ Features

### Core Features

| Feature | Description |
|---------|-------------|
| **🔐 Authentication** | Secure email/password and OTP-based phone authentication with multi-language support (English/Tamil) |
| **👤 User Profiling** | Conversational questionnaire for physical & emotional health assessment |
| **📊 Dashboard** | Personalized greeting, energy status, burnout risk indicator, and quick actions |
| **📝 Daily Check-In** | Track stress levels, energy, mood, sleep, physical activity, and workload intensity |
| **🤖 Burnout Prediction** | AI-powered analysis of daily inputs to calculate and explain burnout risk levels |
| **📈 Insights & Trends** | Wellness score gauge, weekly burnout trends, and stress/energy visualizations |
| **💡 Interventions** | Personalized recommendations for rest, exercise, mindfulness, and community support |
| **💬 Emotional Support** | Daily affirmations, validation messages, and optional journaling |
| **⏰ Personal Time Tracker** | Track me-time with weekly progress views and gentle reminders |
| **🔔 Alerts & Notifications** | Customizable burnout alerts and self-care nudges |
| **📚 Community/Blog** | Mental health articles and homemaker-focused content |
| **⚙️ Profile & Settings** | Edit profile, language preferences, notification settings, and data management |

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** (SDK 3.0.0+) - Cross-platform mobile framework
- **Material UI** - Custom themed design system
- **Provider** (^6.1.1) - State management
- **fl_chart** (^0.66.0) - Data visualization
- **google_fonts** (^6.1.0) - Typography

### Backend / Cloud Services
- **Firebase Authentication** - Email/Password & Phone OTP
- **Cloud Firestore** - NoSQL database
- **Firebase Cloud Messaging** - Push notifications
- **Firebase Storage** - File storage (optional)

### Architecture
- ✅ Clean, modular architecture
- ✅ Rule-based burnout prediction (ML-ready)
- ✅ Offline-tolerant design
- ✅ Accessibility-first approach

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget with routing
│
├── core/                     # Core functionality
│   ├── theme/
│   │   └── app_theme.dart    # App-wide theme configuration
│   ├── constants/
│   │   └── app_constants.dart # App constants
│   └── utils/
│       ├── formatters.dart   # Data formatting utilities
│       └── validators.dart   # Input validation utilities
│
├── services/               # Business logic services
│   ├── auth_service.dart    # Authentication service
│   ├── firestore_service.dart # Firestore operations
│   └── notification_service.dart # Push notifications
│
├── models/                  # Data models
│   ├── user_model.dart      # User data model
│   ├── daily_log_model.dart # Daily check-in model
│   └── burnout_model.dart   # Burnout assessment model
│
├── providers/               # State management
│   ├── user_provider.dart   # User state provider
│   └── burnout_provider.dart # Burnout state provider
│
├── screens/                 # UI screens
│   ├── splash/              # Splash screen
│   ├── onboarding/          # Onboarding flow
│   ├── auth/                # Login/OTP screens
│   ├── consent/             # Consent screen
│   ├── profiling/           # User profiling
│   ├── dashboard/           # Main dashboard
│   ├── daily_checkin/       # Daily check-in
│   ├── insights/            # Insights & trends
│   ├── interventions/       # Intervention suggestions
│   ├── emotional_support/   # Emotional support
│   ├── personal_time/       # Personal time tracker
│   ├── community_blog/      # Community content
│   ├── alerts/              # Alerts screen
│   ├── profile_settings/    # Profile & settings
│   └── help_support/        # Help & support
│
└── widgets/                 # Reusable widgets
    ├── app_logo.dart        # App logo widget
    ├── burnout_indicator.dart # Burnout level indicator
    ├── wellness_score_gauge.dart # Wellness score visualization
    ├── gradient_button.dart # Custom gradient button
    └── quote_card.dart      # Quote display card
```

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.0.0 or higher)
   ```bash
   flutter --version
   ```

2. **Firebase Account**
   - Create a project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Cloud Messaging

3. **Development Environment**
   - **Android**: Android Studio with Android SDK
   - **iOS**: Xcode (macOS only) with CocoaPods
   - **Editor**: VS Code or Android Studio with Flutter extensions

---

## 🚀 Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/KathirEzhil/imagine_cup--THOZHI.git
cd imagine_cup--THOZHI
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Verify Flutter Setup

```bash
flutter doctor
```

Ensure all required components are installed and configured.

---

## 🔥 Firebase Setup

### Option 1: Using FlutterFire CLI (Recommended)

1. **Install Firebase CLI and FlutterFire CLI**
   ```bash
   npm install -g firebase-tools
   firebase login
   flutter pub global activate flutterfire_cli
   ```

2. **Configure Firebase**
   ```bash
   flutterfire configure
   ```
   
   This will automatically:
   - Detect your Firebase projects
   - Generate `firebase_options.dart`
   - Configure platform-specific settings

### Option 2: Manual Setup

#### Android Configuration

1. **Download Configuration File**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project → Project Settings
   - Download `google-services.json`
   - Place it in `android/app/`

2. **Update Gradle Files**

   **`android/build.gradle`:**
   ```gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

   **`android/app/build.gradle`:**
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### iOS Configuration

1. **Download Configuration File**
   - Go to Firebase Console → Project Settings
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`

2. **Update Podfile**
   ```ruby
   platform :ios, '12.0'
   ```

3. **Install Pods**
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Firebase Configuration File

If using manual setup, create `lib/core/config/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' 
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

### Update app.dart

Ensure `lib/app.dart` initializes Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'core/config/firebase_options.dart';

// In _initializeApp:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Firebase Security Rules

Set up Firestore security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId;
    }
    
    // Daily logs - users can only access their own logs
    match /daily_logs/{logId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Burnout assessments - users can only access their own assessments
    match /burnout_assessments/{assessmentId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Notifications - users can only access their own notifications
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

### Enable Firebase Services

In Firebase Console, enable the following services:

- **Authentication**: 
  - Enable Email/Password
  - Enable Phone authentication
  
- **Firestore Database**: 
  - Create database in production mode
  - Apply security rules (see above)
  
- **Cloud Messaging**: 
  - No additional setup required (works automatically)

---

## ▶️ Running the App

### Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run with specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Debug Mode

```bash
flutter run --debug
```

### Release Mode

```bash
flutter run --release
```

---

## 📦 Building for Production

### Android

**APK (for direct installation):**
```bash
flutter build apk --release
```

**App Bundle (for Google Play Store):**
```bash
flutter build appbundle --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
flutter build ios --release
```

**Note**: iOS builds require:
- macOS with Xcode installed
- Valid Apple Developer account
- Proper code signing setup

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/user_provider_test.dart
```

### Test Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

---

## 🔐 Security & Privacy

Thozhi is built with security and privacy as top priorities:

- ✅ **Firebase Security Rules** - Enforce data access control
- ✅ **Encrypted Data** - All data encrypted in transit and at rest
- ✅ **No Ads** - Zero advertising or data selling
- ✅ **Privacy-First Design** - Minimal data collection
- ✅ **User Control** - Users can export or delete their data anytime
- ✅ **Secure Authentication** - Industry-standard authentication methods

---

## 🎨 Design Principles

Thozhi follows these core design principles:

- **🌈 Soft Colors** - No harsh alerts, only gentle, supportive visuals
- **💬 Friendly Tone** - Validating, empathetic language throughout
- **♿ Accessibility** - Large buttons, readable fonts, high contrast
- **⌨️ Minimal Typing** - Quick selections and sliders over text input
- **📡 Offline Support** - Core features work without internet
- **❤️ Empathetic UX** - Designed specifically for homemakers' needs

---

## 🤝 Contributing

This project was developed as an MVP for a hackathon. For production use, consider:

- ✅ Adding comprehensive unit and widget tests
- ✅ Implementing robust error handling and logging
- ✅ Adding analytics for user behavior insights
- ✅ Improving ML model integration for better predictions
- ✅ Adding support for more languages
- ✅ Enhancing accessibility features
- ✅ Implementing CI/CD pipelines
- ✅ Adding comprehensive documentation

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Built with empathy for homemakers who deserve recognition, support, and care.

Special thanks to:
- The Flutter and Firebase communities
- All homemakers who inspired this project
- Mental health advocates and professionals

---

## ⚠️ Important Disclaimer

**This app is not a substitute for professional medical advice, diagnosis, or treatment.**

Always seek the advice of qualified healthcare providers with any questions you may have regarding a medical condition. Never disregard professional medical advice or delay in seeking it because of something you have read or experienced in this app.

If you are experiencing a medical emergency, please call your local emergency services immediately.

---

<div align="center">

**Made with ❤️ for homemakers**

[Report Bug](https://github.com/KathirEzhil/imagine_cup--THOZHI/issues) · [Request Feature](https://github.com/KathirEzhil/imagine_cup--THOZHI/issues) · [Documentation](https://github.com/KathirEzhil/imagine_cup--THOZHI/wiki)

</div>
