# 🚀 START HERE - Quick Firebase Setup Guide

## 📌 What You Need to Do (In Order)

Follow these steps **one by one**. Don't skip any step!

---

## ✅ STEP 1: Create Firebase Project (5 minutes)

1. Go to: **https://console.firebase.google.com/**
2. Sign in with Google
3. Click **"Add project"**
4. Name it: **"thozhi"**
5. Click through the setup (Analytics doesn't matter)
6. Wait for it to finish

**✅ Done when:** You see "Your project is ready"

---

## ✅ STEP 2: Install FlutterFire Tool (2 minutes)

Open **Terminal/Command Prompt** and type:

```bash
dart pub global activate flutterfire_cli
```

Wait for it to finish.

**✅ Done when:** You see "Activated flutterfire_cli..."

---

## ✅ STEP 3: Connect App to Firebase (3 minutes)

In the same terminal, make sure you're in your project folder:

```bash
cd "C:\Users\Kathir Ezhil A\Downloads\thozhi"
```

Then type:

```bash
flutterfire configure
```

**What to do:**
1. Select your **"thozhi"** project (use arrow keys, press Enter)
2. Select **"android"** (press Spacebar to select, then Enter)
3. Press Enter for package name (use default)

**✅ Done when:** You see "Firebase configuration complete!"

---

## ✅ STEP 4: Update Code (2 minutes)

The file `lib/app.dart` has already been updated for you! ✅

Just make sure the file `lib/firebase_options.dart` exists (it should, after Step 3).

---

## ✅ STEP 5: Enable Authentication (3 minutes)

1. Go to Firebase Console: **https://console.firebase.google.com/**
2. Click **"Build"** → **"Authentication"**
3. Click **"Get started"** (if you see it)
4. Click **"Sign-in method"** tab
5. Click **"Email/Password"** → Toggle **ON** → Click **"Save"**
6. Click **"Phone"** → Toggle **ON** → Click **"Save"**

**✅ Done when:** Both show "Enabled"

---

## ✅ STEP 6: Create Firestore Database (3 minutes)

1. In Firebase Console, click **"Build"** → **"Firestore Database"**
2. Click **"Create database"**
3. Select **"Start in production mode"** → Click **"Next"**
4. Choose a location → Click **"Enable"**
5. Wait for it to create

**✅ Done when:** You see the Firestore page

---

## ✅ STEP 7: Add Security Rules (2 minutes)

1. In Firestore, click **"Rules"** tab
2. **Delete** all existing rules
3. **Copy and paste** this:

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

4. Click **"Publish"**

**✅ Done when:** You see "Published" status

---

## ✅ STEP 8: Test the App (5 minutes)

In your terminal:

```bash
flutter clean
flutter pub get
flutter run
```

**✅ Done when:** App launches and you can sign up!

---

## 🎉 That's It!

Your app should now work with Firebase!

---

## 📖 Need More Details?

Read the complete guide: **FIREBASE_SETUP_STEP_BY_STEP.md**

---

## 🆘 Having Problems?

**Error: "firebase_options.dart not found"**
→ You didn't complete Step 3. Run `flutterfire configure` again.

**Error: "Permission denied"**
→ You didn't complete Step 7. Check your Firestore rules.

**Error: "Email already in use"**
→ Normal! The user exists. Try logging in instead.

**App crashes on startup**
→ Check terminal for error. Make sure you completed all steps.

---

**Total Time:** ~20 minutes  
**Difficulty:** Easy (just follow the steps!)

Good luck! 🚀
