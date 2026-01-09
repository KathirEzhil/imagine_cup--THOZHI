# How to Run the Thozhi App

## ✅ Prerequisites Check

1. **Flutter SDK**: Make sure Flutter is installed and on PATH
   ```bash
   flutter doctor
   ```

2. **Dependencies**: Install dependencies
   ```bash
   flutter pub get
   ```

## 🚀 Running the App

### Option 1: Run on Connected Device/Emulator

```bash
flutter run
```

This will:
- Automatically detect connected devices/emulators
- Ask you to select which device to use
- Build and install the app
- Launch the app

### Option 2: Run on Specific Device

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Option 3: Run in Release Mode (for testing performance)

```bash
flutter run --release
```

## 📱 Available Platforms

- **Android**: Full support (requires Android SDK)
- **iOS**: Full support (requires macOS and Xcode)
- **Web**: Basic support (not fully tested)
- **Windows/Linux/MacOS**: Not configured (mobile-only app)

## ⚠️ Common Issues

### Issue: "No devices found"
**Solution**: 
- Start an Android emulator from Android Studio
- Or connect a physical device via USB (enable USB debugging)

### Issue: "Gradle build failed"
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "Firebase not initialized"
**Solution**: 
- This is expected if Firebase isn't configured
- The app will still run and show all screens
- For full functionality, see `FIREBASE_PLACEHOLDER.md` or `SETUP_FIREBASE.md`

### Issue: "Missing dependencies"
**Solution**:
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Issue: "Build errors"
**Solution**:
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

## 🎯 Quick Test Checklist

After running the app, verify:

- [ ] Splash screen appears
- [ ] Onboarding screens work
- [ ] Consent screen displays
- [ ] Login/Sign up screens load
- [ ] Navigation works
- [ ] Dashboard displays
- [ ] All screens are accessible
- [ ] No crashes

## 📝 Notes

- **Firebase Setup**: Optional for UI demo, required for full functionality
- **First Run**: May take longer as it compiles everything
- **Hot Reload**: Press `r` in terminal while app is running to hot reload
- **Hot Restart**: Press `R` in terminal to hot restart
- **Quit**: Press `q` in terminal to quit

## 🔧 Development Tips

1. **Enable Hot Reload**: Edit code and save, changes appear instantly
2. **Debug Console**: Check terminal for debug output
3. **Performance**: Use `flutter run --profile` for performance profiling
4. **Build APK**: Use `flutter build apk` to create installable APK

---

**The app is ready to run!** Simply execute `flutter run` in the project directory.
