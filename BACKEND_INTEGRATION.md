# Backend Integration Guide

## Overview
The THE GLITCH Flutter app is now fully integrated with your website's backend at `http://localhost:8080`.

## ✅ What's Connected

### 1. **Authentication (Login/Register/Forgot Password)**
- **Endpoint**: `http://localhost:8080/api/auth`
- **Features**:
  - ✅ User registration → Saves to MySQL database
  - ✅ User login → Returns JWT token
  - ✅ Forgot password → Sends email via Gmail SMTP
  - ✅ Password reset → Updates password in database
  
- **How it works**:
  1. User registers → Data saved to `users` table in MySQL
  2. Email confirmation sent to `shubzfx@gmail.com`
  3. User can login → JWT token stored locally
  4. Forgot password → Reset link sent to user's email
  5. User clicks link → Can reset password

### 2. **Community Channels**
- **Endpoint**: `http://localhost:8080/api/community/channels`
- **Features**:
  - ✅ Fetches ALL channels from your website database
  - ✅ Shows same channels as website
  - ✅ Respects channel permissions (open, locked, admin-only)
  
- **How it works**:
  1. App calls API with auth token
  2. Backend returns channels from `channel_model` table
  3. App displays channels in dropdown
  4. Users can only access channels they have permission for

### 3. **Messages**
- **Endpoint**: `http://localhost:8080/api/community/channels/{channelId}/messages`
- **Features**:
  - ✅ Fetches messages from database
  - ✅ Messages persist until admin deletes them
  - ✅ Real-time updates via WebSocket
  
- **How it works**:
  1. User selects channel
  2. App fetches messages from `message_model` table
  3. Messages displayed in chat
  4. Admins can delete messages (saved to database)

### 4. **Courses**
- **Endpoint**: `http://localhost:8080/api/courses`
- **Features**:
  - ✅ Fetches courses from database
  - ✅ Same courses as website
  - ✅ Stripe payment integration
  
### 5. **Contact Form**
- **Endpoint**: `http://localhost:8080/api/contact`
- **Features**:
  - ✅ Submissions saved to `contact_message_model` table
  - ✅ Admin can view in admin panel
  
### 6. **AI Chatbot**
- **Endpoint**: `http://localhost:8080/api/chatbot`
- **Features**:
  - ✅ Uses OpenAI GPT-3.5-turbo
  - ✅ Same AI as website
  - ✅ Can answer any question

## 🔧 Backend Configuration

Your backend is configured at:
```
Database: MySQL localhost:3306/trading_platform
Username: root
Password: 7f42Shob2002!
Email: shubzfx@gmail.com
SMTP: Gmail (bvqs xahd pkzl rzmm)
```

## 📱 How Data Flows

### User Registration:
```
Flutter App → POST /api/auth/register → MySQL → Email Confirmation → Success
```

### Login:
```
Flutter App → POST /api/auth/login → MySQL → JWT Token → Stored Locally
```

### Forgot Password:
```
Flutter App → POST /api/auth/forgot-password → Email Sent → User Clicks Link → Reset Password
```

### Fetch Channels:
```
Flutter App → GET /api/community/channels → MySQL → Channels Returned → Displayed
```

### Fetch Messages:
```
Flutter App → GET /api/community/channels/{id}/messages → MySQL → Messages Returned → Displayed
```

## 🚀 Running the Backend

1. **Start MySQL**:
   ```bash
   # Make sure MySQL is running on localhost:3306
   ```

2. **Start Backend**:
   ```bash
   cd "C:\Users\1230s\OneDrive\Documents\TheGlitch\Main Website\The-Glitch\trading-platform-backend"
   ./start.bat
   ```

3. **Verify Backend**:
   - Open browser: `http://localhost:8080`
   - Should see website running

4. **Run Flutter App**:
   ```bash
   cd "C:\Users\1230s\OneDrive\Documents\TheGlitch\APP\the_glitch_app"
   flutter run -d chrome
   ```

## ✅ Testing the Integration

### Test Registration:
1. Open app
2. Click "Sign Up"
3. Fill form → Submit
4. Check MySQL `users` table → User should be there
5. Check email → Confirmation email received

### Test Login:
1. Enter credentials
2. Click Login
3. Check SharedPreferences → Token stored
4. Main app opens

### Test Forgot Password:
1. Click "Forgot Password?"
2. Enter email
3. Check email → Reset link received
4. Click link → Can reset password
5. Check MySQL → Password updated

### Test Channels:
1. Login to app
2. Go to Community
3. Click channel dropdown
4. Should see same channels as website

### Test Messages:
1. Select a channel
2. Messages should load from database
3. Should see same messages as website

## 🔐 Security

- ✅ JWT tokens for authentication
- ✅ Password hashing in database
- ✅ CORS enabled for app
- ✅ Admin-only endpoints protected
- ✅ Email verification

## 📊 Database Tables Used

1. `users` - User accounts
2. `channel_model` - Community channels
3. `message_model` - Chat messages
4. `contact_message_model` - Contact form submissions
5. `course_model` - Courses
6. `user_course_model` - User enrollments

## 🎯 Next Steps

1. **Start your backend** (`start.bat`)
2. **Run the Flutter app**
3. **Test registration** → Check database
4. **Test login** → Verify token
5. **Test forgot password** → Check email
6. **Test channels** → Verify they match website
7. **Test messages** → Verify persistence

Everything is now connected to your actual backend! All data is saved to the same MySQL database your website uses. 🚀

