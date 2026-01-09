# 🔥 Firebase Setup - Complete Step-by-Step Guide

## 📋 Overview
This guide will help you set up Firebase for your Thozhi app so that authentication and data storage work properly.

**Time Required:** 15-20 minutes  
**Difficulty:** Beginner-friendly

---

## ✅ STEP 1: Create a Firebase Account (If You Don't Have One)

### What to do:
1. Open your web browser
2. Go to: **https://console.firebase.google.com/**
3. Click **"Sign in"** (top right)
4. Sign in with your **Google account** (Gmail account)
   - If you don't have a Google account, create one first at gmail.com

**✅ Checkpoint:** You should see the Firebase Console homepage

---

## ✅ STEP 2: Create a New Firebase Project

### What to do:
1. In Firebase Console, click the **"Add project"** button (or "Create a project")
2. **Project name:** Type `thozhi` (or any name you like)
   - Click **Continue**
3. **Google Analytics:** 
   - You can turn it **ON** or **OFF** (doesn't matter for now)
   - If ON, select or create an Analytics account
   - Click **Continue**
4. **Wait** for project creation (takes 10-30 seconds)
5. Click **"Continue"** when it's done

**✅ Checkpoint:** You should see "Your project is ready" message

---

## ✅ STEP 3: Install FlutterFire CLI Tool

### What to do:
1. Open **Command Prompt** or **PowerShell** or **Terminal** in VS Code
2. Type this command and press **Enter**:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. **Wait** for it to install (takes 30-60 seconds)
4. You should see: "Activated flutterfire_cli..."

**✅ Checkpoint:** No errors should appear

**⚠️ If you get an error:**
- Make sure Flutter is installed: Run `flutter doctor`
- Restart your terminal/VS Code after installation

---

## ✅ STEP 4: Navigate to Your Project Folder

### What to do:
1. In your terminal/command prompt, type:
   ```bash
   cd "C:\Users\Kathir Ezhil A\Downloads\thozhi"
   ```
2. Press **Enter**
3. Verify you're in the right place by typing:
   ```bash
   dir
   ```
   (or `ls` on Mac/Linux)
4. You should see folders like `lib`, `android`, `pubspec.yaml`

**✅ Checkpoint:** You're in the thozhi project folder

---

## ✅ STEP 5: Connect Your App to Firebase

### What to do:
1. In the same terminal, type:
   ```bash
   flutterfire configure
   ```
2. Press **Enter**

### What will happen:
1. **First question:** "Which Firebase project would you like to use?"
   - You'll see a list of your Firebase projects
   - Use arrow keys to select **"thozhi"** (the project you created in Step 2)
   - Press **Enter**

2. **Second question:** "Which platforms should your app support?"
   - You'll see: `[ ] android`, `[ ] ios`, `[ ] web`, etc.
   - Press **Spacebar** to select **android** (you'll see `[x] android`)
   - If you want iOS later, select that too
   - Press **Enter** when done

3. **Third question:** "What is the package name for android?"
   - It will show something like: `com.example.thozhi`
   - Just press **Enter** to accept (or type a different one if you want)

4. **Wait** - It will download files and configure everything automatically

**✅ Checkpoint:** You should see "Firebase configuration complete!"

**📁 What was created:**
- A file called `lib/firebase_options.dart` (this is important!)
- Updated `android/app/google-services.json` (if it didn't exist)

---

## ✅ STEP 6: Update Your App Code

### What to do:
1. Open the file: `lib/app.dart` in your code editor
2. Find this section (around line 27-40):
   ```dart
   Future<void> _initializeApp() async {
     try {
       // Initialize Firebase
       // Note: For production, use flutterfire configure to auto-generate firebase_options.dart
       // Then update the import and use: await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
       
       // For MVP/demo without full Firebase setup:
       // This will work if Firebase is configured, or fail gracefully if not
       try {
         // Try to initialize Firebase - will work if google-services.json/GoogleService-Info.plist exists
         await Firebase.initializeApp();
         debugPrint('Firebase initialized successfully');
       } on FirebaseException catch (e) {
         debugPrint('Firebase initialization error: ${e.message}');
         debugPrint('Note: Firebase setup required for full functionality. See SETUP_FIREBASE.md');
       } catch (e) {
         debugPrint('Firebase initialization skipped (use flutterfire configure for full setup): $e');
       }
   ```

3. **Replace** that entire section with this:
   ```dart
   Future<void> _initializeApp() async {
     try {
       // Initialize Firebase with the generated options
       await Firebase.initializeApp(
         options: DefaultFirebaseOptions.currentPlatform,
       );
       debugPrint('Firebase initialized successfully');
       
       // Initialize notification service
       try {
         await _notificationService.initialize();
         debugPrint('Notification service initialized');
       } catch (e) {
         debugPrint('Notification service initialization skipped: $e');
       }
       
       setState(() {
         _initialized = true;
       });
     } catch (e) {
       // Handle initialization error
       debugPrint('Error initializing app: $e');
       setState(() {
         _initialized = true; // Still show app even if services fail
       });
     }
   }
   ```

4. **Add this import** at the top of the file (with other imports):
   ```dart
   import 'firebase_options.dart';
   ```

5. **Save** the file (Ctrl+S or Cmd+S)

**✅ Checkpoint:** Your `app.dart` file should now import `firebase_options.dart` and use `DefaultFirebaseOptions.currentPlatform`

---

## ✅ STEP 7: Enable Authentication in Firebase Console

### What to do:
1. Go back to **Firebase Console** in your browser: https://console.firebase.google.com/
2. Make sure you're in the **"thozhi"** project (check top-left)
3. In the left sidebar, click **"Build"** → **"Authentication"**
4. Click **"Get started"** button (if you see it)
5. Click the **"Sign-in method"** tab (at the top)
6. You'll see a list of sign-in providers

### Enable Email/Password:
1. Click on **"Email/Password"** in the list
2. Toggle **"Enable"** to **ON** (the switch at the top)
3. Click **"Save"**

### Enable Phone (for OTP):
1. Click on **"Phone"** in the list
2. Toggle **"Enable"** to **ON**
3. Click **"Save"**

**✅ Checkpoint:** Both Email/Password and Phone should show "Enabled" status

---

## ✅ STEP 8: Create Firestore Database

### What to do:
1. In Firebase Console, click **"Build"** → **"Firestore Database"** (in left sidebar)
2. Click **"Create database"** button
3. **Security rules:** Select **"Start in production mode"**
   - Click **"Next"**
4. **Cloud Firestore location:**
   - Choose a location close to you (e.g., `us-central`, `asia-south1` for India)
   - Click **"Enable"**
5. **Wait** for database creation (takes 10-30 seconds)

**✅ Checkpoint:** You should see "Cloud Firestore" page with "No data" message

---

## ✅ STEP 9: Set Up Firestore Security Rules

### What to do:
1. In Firestore Database page, click the **"Rules"** tab (at the top)
2. You'll see some default rules
3. **Delete** all the existing rules
4. **Copy and paste** this code:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /daily_logs/{logId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == resource.data.userId;
       }
       match /burnout_assessments/{assessmentId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == resource.data.userId;
       }
       match /notifications/{notificationId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == resource.data.userId;
       }
     }
   }
   ```
5. Click **"Publish"** button (top right)
6. You should see a success message

**✅ Checkpoint:** Rules should show "Published" status

**🔒 What this does:** These rules ensure users can only access their own data

---

## ✅ STEP 10: Test Your Setup

### What to do:
1. Go back to your **terminal/command prompt**
2. Make sure you're in the project folder:
   ```bash
   cd "C:\Users\Kathir Ezhil A\Downloads\thozhi"
   ```
3. Clean and rebuild:
   ```bash
   flutter clean
   ```
4. Get dependencies:
   ```bash
   flutter pub get
   ```
5. Check for connected devices:
   ```bash
   flutter devices
   ```
   - You should see at least one device (emulator or physical device)
   - If not, start an Android emulator from Android Studio

6. Run the app:
   ```bash
   flutter run
   ```

**✅ Checkpoint:** App should launch without Firebase errors

---

## ✅ STEP 11: Test Authentication

### What to do:
1. When the app opens, go through:
   - Splash screen
   - Onboarding screens
   - Consent screen
2. On the **Login/Sign up** screen:
3. Click **"Sign up to register"**
4. Fill in:
   - **Name:** Your name
   - **Email:** A test email (e.g., `test@example.com`)
   - **Password:** Any password (e.g., `test123`)
5. Click **"Sign Up"**
6. **Check Firebase Console:**
   - Go to **Authentication** → **Users** tab
   - You should see your test user appear!

**✅ Checkpoint:** User should be created in Firebase Authentication

---

## ✅ STEP 12: Test Daily Check-In

### What to do:
1. In the app, complete the **Profile Creation** (if asked)
2. Go to **Dashboard**
3. Click **"tap to complete the daily check in for today"**
4. Fill in the form:
   - Stress level: Move slider
   - Energy: Select a level
   - Mood: Tap an emoji
   - Sleep: Move slider
   - Activity: Move slider
   - Workload: Move slider
5. Click **"Complete Check-In"**
6. **Check Firebase Console:**
   - Go to **Firestore Database** → **Data** tab
   - You should see a collection called `daily_logs` with your data!

**✅ Checkpoint:** Data should appear in Firestore

---

## 🎉 Success! Your Firebase is Set Up!

If everything worked:
- ✅ Authentication works (you can sign up/login)
- ✅ Data is saved to Firestore
- ✅ App runs without errors

---

## 🆘 Troubleshooting

### Problem: "Firebase not initialized" error
**Solution:**
- Make sure you completed Step 6 (updated `app.dart`)
- Check that `lib/firebase_options.dart` exists
- Run `flutter clean` and `flutter pub get` again

### Problem: "Permission denied" in Firestore
**Solution:**
- Check Step 9 - make sure security rules are published
- Verify the rules code is exactly as shown

### Problem: "Email already in use" when signing up
**Solution:**
- This is normal! The user already exists
- Try logging in instead, or use a different email

### Problem: Phone OTP not working
**Solution:**
- For Android, you need to add SHA-1 fingerprint
- Go to Firebase Console → Project Settings → Your Android app
- Add SHA-1 key (can get it with: `keytool -list -v -keystore ~/.android/debug.keystore`)
- For now, just use Email/Password authentication

### Problem: App crashes on startup
**Solution:**
- Check terminal for error messages
- Make sure `google-services.json` is in `android/app/` folder
- Verify `firebase_options.dart` exists in `lib/` folder

---

## 📝 Quick Reference

**Firebase Console:** https://console.firebase.google.com/  
**Your Project:** thozhi (or whatever you named it)

**Important Files:**
- `lib/firebase_options.dart` - Auto-generated by flutterfire configure
- `android/app/google-services.json` - Auto-added by flutterfire configure
- `lib/app.dart` - You updated this to use Firebase

**Commands to Remember:**
```bash
flutterfire configure    # Connect app to Firebase
flutter clean            # Clean build files
flutter pub get          # Install dependencies
flutter run              # Run the app
```

---

## ✅ Final Checklist

Before you consider setup complete, verify:

- [ ] Firebase project created
- [ ] FlutterFire CLI installed
- [ ] `flutterfire configure` completed successfully
- [ ] `lib/app.dart` updated with `firebase_options.dart` import
- [ ] Email/Password authentication enabled
- [ ] Phone authentication enabled (optional)
- [ ] Firestore database created
- [ ] Security rules published
- [ ] App runs without Firebase errors
- [ ] Can create a user account
- [ ] Can save data to Firestore

---

**🎊 Congratulations! Your Thozhi app is now fully connected to Firebase!**

If you get stuck at any step, let me know which step number and what error you see, and I'll help you fix it!
