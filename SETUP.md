# THE GLITCH App - Quick Setup Guide

## Prerequisites

1. **Flutter SDK** - Already installed at:
   ```
   C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter
   ```

2. **Android Studio** or **VS Code** with Flutter extensions

3. **Git** - Already configured

## Running the App

### Option 1: Using the Local Flutter Installation

1. Open terminal in the project directory:
   ```bash
   cd C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\the_glitch_app
   ```

2. Run the app:
   ```bash
   C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter\bin\flutter.bat run
   ```

### Option 2: Using VS Code

1. Open the project folder in VS Code
2. Select a device (Android emulator, iOS simulator, or physical device)
3. Press F5 or click "Run" → "Start Debugging"

### Option 3: Build APK for Android

```bash
cd C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\the_glitch_app
C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter\bin\flutter.bat build apk --release
```

The APK will be in: `build/app/outputs/flutter-apk/app-release.apk`

## Testing on Different Platforms

### Android
```bash
flutter run -d android
```

### iOS (Mac only)
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d chrome
```

### Windows Desktop
```bash
flutter run -d windows
```

## Connecting to Backend

The app currently points to `http://localhost:8080` for the backend API.

To change this:
1. Open `lib/services/api_service.dart`
2. Update the `baseUrl` constant:
   ```dart
   static const String baseUrl = 'https://your-backend-url.com';
   ```

## Backend Endpoints Required

Make sure your backend has these endpoints:

- `POST /api/chatbot` - AI chatbot
  ```json
  Request: {"message": "Hello"}
  Response: {"reply": "Hi! How can I help?"}
  ```

- `POST /api/contact` - Contact form
  ```json
  Request: {"name": "John", "email": "john@example.com", "message": "Help"}
  Response: 200 OK
  ```

- `GET /api/courses` - Get courses list
  ```json
  Response: [
    {"id": "1", "title": "Course Name", "description": "...", "price": 49.99}
  ]
  ```

- `GET /api/community/channels` - Get community channels
  ```json
  Response: [
    {"id": "1", "name": "general", "description": "...", "accessLevel": "open"}
  ]
  ```

- `GET /api/community/channels/:id/messages` - Get channel messages
  ```json
  Response: [
    {
      "id": "1",
      "content": "Hello!",
      "senderId": "user1",
      "senderUsername": "John",
      "timestamp": 1234567890000,
      "senderLevel": 5
    }
  ]
  ```

## Troubleshooting

### "Flutter command not found"
Use the full path to flutter.bat:
```bash
C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter\bin\flutter.bat
```

### "No devices found"
- For Android: Start an emulator in Android Studio
- For Web: Chrome should be available by default
- For Windows: Should work on Windows 10+

### Dependencies Issues
```bash
C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter\bin\flutter.bat pub get
```

### Clean Build
```bash
C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter\bin\flutter.bat clean
C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter\bin\flutter.bat pub get
```

## Development Tips

### Hot Reload
While the app is running, press `r` in the terminal to hot reload changes.

### Hot Restart
Press `R` for a full restart.

### Debug Mode
The app runs in debug mode by default. For better performance testing, use release mode:
```bash
flutter run --release
```

### Check for Issues
```bash
flutter analyze
```

### Format Code
```bash
flutter format lib/
```

## Next Steps

1. **Run the app** using one of the methods above
2. **Test each feature**:
   - Loading screen animation
   - Community channels and messaging
   - Courses listing
   - Contact form
   - AI Chatbot (floating button)
3. **Connect to your backend** by updating the API URL
4. **Build release versions** for distribution

## GitHub Repository

The code is already pushed to:
https://github.com/Shubz69/theglitchapp.git

To pull latest changes:
```bash
git pull origin main
```

## Need Help?

If you encounter any issues:
1. Check the troubleshooting section above
2. Run `flutter doctor` to check your Flutter installation
3. Check the Flutter documentation: https://flutter.dev/docs

