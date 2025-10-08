# THE GLITCH Mobile App

A Flutter mobile application for THE GLITCH trading platform, featuring a Discord-like community, courses, AI chatbot, and contact support.

## Features

### 🎨 Beautiful Loading Screen
- Animated loading screen with THE GLITCH branding
- Binary background effects
- Pulsing rings animation
- Progress indicator

### 💬 AI Customer Support Chatbot
- Floating chatbot widget available on all screens
- Real-time AI responses
- Simulated responses with fallback mode
- Clean, modern chat interface

### 🏘️ Discord-like Community (Main Feature)
- Multiple channels organized by categories
- Real-time messaging functionality
- Channel-specific permissions (read-only, level-based access)
- Beautiful channel sidebar with icons
- Message history
- User avatars and timestamps
- Smooth scrolling and animations

### 📚 Courses Page
- Browse available trading courses
- Course cards with descriptions and pricing
- Free and paid course options
- Direct purchase integration with Stripe
- Refresh to reload courses

### 📧 Contact Us
- Contact form with validation
- Email support integration
- Contact information display
- Beautiful card-based layout

## Design

The app follows your website's color scheme:
- **Primary Color**: #6366F1 (Indigo)
- **Secondary Color**: #8B5CF6 (Purple-Blue)
- **Accent Color**: #A78BFA (Light Purple)
- **Background**: Dark theme with #0F0F1E, #1A1A2E, #252541
- **Typography**: Space Grotesk and Inter fonts from Google Fonts

## Project Structure

```
lib/
├── config/
│   └── theme.dart              # App theme and colors
├── models/
│   ├── channel.dart            # Channel model
│   ├── course.dart             # Course model
│   └── message.dart            # Message model
├── screens/
│   ├── community_screen.dart   # Discord-like community
│   ├── contact_us_screen.dart  # Contact form
│   ├── courses_screen.dart     # Courses listing
│   ├── loading_screen.dart     # Splash/loading screen
│   └── main_screen.dart        # Main navigation
├── services/
│   └── api_service.dart        # API integration
├── widgets/
│   └── chatbot_widget.dart     # Floating AI chatbot
└── main.dart                    # App entry point
```

## Dependencies

- `provider` - State management
- `http` - HTTP requests
- `web_socket_channel` - WebSocket support
- `google_fonts` - Space Grotesk and Inter fonts
- `flutter_svg` - SVG support
- `cached_network_image` - Image caching
- `intl` - Date/time formatting
- `shared_preferences` - Local storage
- `url_launcher` - Open external links

## Setup

1. **Install Flutter**
   - Make sure Flutter SDK is installed and in your PATH
   - Or use the local installation at `C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\flutter\bin\flutter.bat`

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

4. **Build for Release**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## Backend Integration

The app is configured to connect to your backend at `http://localhost:8080`. Update the `baseUrl` in `lib/services/api_service.dart` to point to your production backend.

### API Endpoints Used:
- `POST /api/chatbot` - AI chatbot messages
- `POST /api/contact` - Contact form submissions
- `GET /api/courses` - Fetch courses
- `GET /api/community/channels` - Fetch community channels
- `GET /api/community/channels/:id/messages` - Fetch channel messages

## Features Implementation

### Community (Discord-like)
- ✅ Channel sidebar with categories
- ✅ Channel selection
- ✅ Message display with avatars
- ✅ Real-time message input
- ✅ Read-only channel support
- ✅ Level-based channel access
- ✅ Smooth animations and transitions

### Courses
- ✅ Course listing
- ✅ Free and paid courses
- ✅ Stripe payment integration
- ✅ Course details display
- ✅ Purchase functionality

### Contact Us
- ✅ Form validation
- ✅ Email submission
- ✅ Contact information display
- ✅ Success/error feedback

### AI Chatbot
- ✅ Floating widget
- ✅ Chat interface
- ✅ Message history
- ✅ Simulated responses
- ✅ Backend integration ready

## Screenshots

(Add screenshots here once the app is running)

## Future Enhancements

- [ ] User authentication and login
- [ ] WebSocket integration for real-time community chat
- [ ] Course progress tracking
- [ ] User profiles
- [ ] Push notifications
- [ ] Video player for course content
- [ ] File attachments in community
- [ ] Emoji picker for messages
- [ ] User mentions in community
- [ ] Search functionality

## License

All rights reserved - THE GLITCH Platform

## GitHub Repository

https://github.com/Shubz69/theglitchapp.git
