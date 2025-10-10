# How to Start the Backend

## Quick Start (Recommended)

1. **Open Command Prompt as Administrator**
2. **Navigate to backend directory:**
   ```cmd
   cd "C:\Users\1230s\OneDrive\Documents\TheGlitch\Main Website\The-Glitch\trading-platform-backend"
   ```

3. **Start the backend:**
   ```cmd
   mvn spring-boot:run
   ```

4. **Wait for startup** (look for "Started Application in X seconds")

5. **Test backend is running:**
   - Open browser: `http://localhost:8080`
   - Should see your website

## Alternative Method

If Maven doesn't work, try:

1. **Check if JAR file exists:**
   ```cmd
   dir target\*.jar
   ```

2. **Run the JAR directly:**
   ```cmd
   java -jar target\trading-platform-backend-*.jar
   ```

## Troubleshooting

### If MySQL is not running:
1. **Start MySQL service:**
   ```cmd
   net start mysql
   ```

### If port 8080 is busy:
1. **Check what's using port 8080:**
   ```cmd
   netstat -ano | findstr :8080
   ```

2. **Kill the process:**
   ```cmd
   taskkill /PID <process_id> /F
   ```

## What Happens When Backend Starts

✅ **Database connection** to MySQL  
✅ **Email service** configured (Gmail SMTP)  
✅ **JWT authentication** ready  
✅ **API endpoints** available at `http://localhost:8080/api`  
✅ **WebSocket** for real-time chat  
✅ **Stripe payment** integration  

## Testing the Backend

Once running, test these URLs in browser:

- `http://localhost:8080` - Main website
- `http://localhost:8080/api/auth/login` - Login endpoint
- `http://localhost:8080/api/community/channels` - Channels endpoint

## For Flutter App

Once backend is running:
1. **Refresh the Flutter app** in Chrome
2. **Try forgot password** - should work now!
3. **Register new user** - saves to database
4. **Login** - uses real JWT tokens
5. **Community channels** - loads from database

---

**Note:** The Flutter app will work without the backend (simulation mode), but for full functionality with database and email, the backend must be running.
