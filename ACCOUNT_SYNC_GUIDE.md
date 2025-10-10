# 🔄 ACCOUNT SYNCHRONIZATION - APP & WEBSITE

## ✅ **ACCOUNTS ARE FULLY LINKED!**

Your Flutter app and website share the **same database and backend**, which means:

---

## 🎯 **HOW IT WORKS**

### **Single Source of Truth:**

```
┌─────────────────┐
│  MySQL/H2 DB    │  ← ONE DATABASE
│  (Backend)      │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼────┐
│  APP  │ │ SITE  │
└───────┘ └───────┘
```

Both the app and website connect to:
- **Same Backend**: `http://localhost:8080` (or your production URL)
- **Same Database**: All user accounts stored in ONE place
- **Same JWT Tokens**: Authentication works across both

---

## 🔐 **AUTHENTICATION FLOW**

### **Scenario 1: Register on App → Login on Website**

1. **User registers on Flutter App**:
   ```
   POST http://localhost:8080/api/auth/register
   {
     "username": "john_trader",
     "email": "john@example.com",
     "password": "securepass123",
     "name": "John Doe"
   }
   ```

2. **Account is created in database**:
   ```sql
   INSERT INTO users (username, email, password, ...)
   VALUES ('john_trader', 'john@example.com', '$2a$10$...', ...)
   ```

3. **User can immediately login on Website**:
   ```
   POST http://localhost:8080/api/auth/login
   {
     "email": "john@example.com",
     "password": "securepass123"
   }
   ```
   ✅ **Same account, works on both!**

### **Scenario 2: Register on Website → Login on App**

1. **User registers on Website** → Creates account in database
2. **User opens Flutter App** → Can login with same credentials
3. ✅ **Everything synced automatically!**

---

## 📊 **WHAT'S SHARED BETWEEN APP & WEBSITE**

| Data | Synced? | How? |
|------|---------|------|
| **User Accounts** | ✅ YES | Same users table in database |
| **Passwords** | ✅ YES | Bcrypt hashed, same hash algorithm |
| **JWT Tokens** | ✅ YES | Same secret key, works on both |
| **User Profiles** | ✅ YES | Name, email, avatar, bio all synced |
| **User Roles** | ✅ YES | Admin/User/Premium role synced |
| **User Levels** | ✅ YES | XP and level progression synced |
| **Community Messages** | ✅ YES | Real-time sync via WebSocket |
| **Course Enrollments** | ✅ YES | user_courses table shared |
| **Payment History** | ✅ YES | Same Stripe integration |
| **Profile Updates** | ✅ YES | Changes reflect immediately |

---

## 🧪 **TESTING ACCOUNT SYNC**

### **Test 1: Registration Sync**

**On Flutter App:**
1. Open app: `http://localhost:3000`
2. Click "Sign Up"
3. Register with:
   - Username: `testuser123`
   - Email: `test@example.com`
   - Password: `test123`

**On Website:**
1. Open website: `http://your-website.com`
2. Try to login with:
   - Email: `test@example.com`
   - Password: `test123`
3. ✅ **Should work immediately!**

### **Test 2: Profile Update Sync**

**On App:**
1. Login
2. Update profile (name, bio, avatar)
3. Save changes → `PUT /api/users/{id}`

**On Website:**
1. Login with same account
2. ✅ **Profile changes are visible!**

### **Test 3: Password Reset Sync**

**On App:**
1. Click "Forgot Password"
2. Enter email
3. Reset password via email link
4. ✅ **New password works on website too!**

---

## 🔧 **TECHNICAL IMPLEMENTATION**

### **Backend Configuration:**

Both app and website use the same backend endpoints:

```javascript
// Website (React)
const API_URL = 'http://localhost:8080/api';

// Flutter App
const String baseUrl = 'http://localhost:8080';
```

### **Database Schema:**

```sql
-- Users table (SHARED by both platforms)
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,      -- Bcrypt hashed
    name VARCHAR(255),
    role VARCHAR(255) NOT NULL,          -- ADMIN, USER, PREMIUM
    avatar VARCHAR(255),
    bio VARCHAR(255),
    phone VARCHAR(255),
    address VARCHAR(255),
    muted BOOLEAN NOT NULL,
    mfa_verified BOOLEAN NOT NULL,
    mfa_code VARCHAR(255),
    agreed_to_rules BOOLEAN NOT NULL,
    last_seen TIMESTAMP
);
```

### **Authentication Service:**

**Flutter App (`auth_service.dart`):**
```dart
static Future<bool> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/auth/login'),  // Same endpoint!
    body: jsonEncode({'email': email, 'password': password}),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // Store JWT token
    await prefs.setString(_tokenKey, data['token']);
    return true;
  }
  return false;
}
```

**Website (React):**
```javascript
const login = async (email, password) => {
  const response = await fetch('http://localhost:8080/api/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password })
  });
  
  const data = await response.json();
  // Store same JWT token
  localStorage.setItem('token', data.token);
};
```

✅ **Same backend, same JWT, same user!**

---

## 🔐 **JWT TOKEN SYNCHRONIZATION**

### **How JWT Tokens Work:**

1. **User logs in** (app or website)
2. **Backend generates JWT** with user info:
   ```json
   {
     "sub": "user@example.com",
     "id": 123,
     "role": "USER",
     "exp": 1696867200
   }
   ```
3. **Token is signed** with same secret key
4. ✅ **Token works on both platforms!**

### **Token Storage:**

- **Flutter App**: `SharedPreferences` (key: `auth_token`)
- **Website**: `localStorage` (key: `token`)

Both send the token in requests:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 📱 **REAL-WORLD USE CASES**

### **Use Case 1: Mobile User**
1. Downloads Flutter app
2. Registers account
3. Later opens website on desktop
4. ✅ **Logs in with same credentials**
5. ✅ **All data is there!**

### **Use Case 2: Website User**
1. Uses website on laptop
2. Enrolls in courses
3. Downloads mobile app
4. ✅ **Logs in with same account**
5. ✅ **Course progress synced!**

### **Use Case 3: Admin User**
1. Admin on website deletes a message
2. ✅ **Message disappears from app instantly** (WebSocket)
3. Admin bans a user on app
4. ✅ **User can't login on website** (same database)

---

## 🌐 **PRODUCTION SETUP**

### **For Production Deployment:**

1. **Update Backend URL:**

**Flutter App:**
```dart
// In lib/services/api_service.dart
static const String baseUrl = 'https://api.theglitch.online';
```

**Website:**
```javascript
// In config/api.js
const API_URL = 'https://api.theglitch.online';
```

2. **Database:**
```properties
# Switch from H2 to MySQL
spring.datasource.url=jdbc:mysql://your-db-host:3306/theglitch
spring.datasource.username=your_username
spring.datasource.password=your_password
```

3. **CORS Configuration:**
```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                    .allowedOrigins(
                        "https://theglitch.online",      // Website
                        "https://app.theglitch.online"   // Flutter app
                    )
                    .allowedMethods("GET", "POST", "PUT", "DELETE")
                    .allowCredentials(true);
            }
        };
    }
}
```

---

## ✅ **VERIFICATION CHECKLIST**

Test these to confirm account sync is working:

- [ ] Register on app → Login on website ✅
- [ ] Register on website → Login on app ✅
- [ ] Update profile on app → See changes on website ✅
- [ ] Send community message on app → Appears on website ✅
- [ ] Enroll in course on website → Access on app ✅
- [ ] Admin deletes message → Removed from both ✅
- [ ] Password reset → Works on both ✅
- [ ] JWT token → Valid on both ✅

---

## 🎉 **SUMMARY**

### **Yes, accounts are 100% linked!**

- ✅ **Same Database** → All user data in one place
- ✅ **Same Backend** → Both connect to same API
- ✅ **Same Authentication** → JWT works everywhere
- ✅ **Real-time Sync** → WebSocket for instant updates
- ✅ **Same User Experience** → Seamless across platforms

### **What This Means:**

1. **Create account anywhere** → Works everywhere
2. **Login anywhere** → Same credentials
3. **Update anywhere** → Changes sync everywhere
4. **Pay once** → Access on all platforms
5. **Community messages** → Shared across all users

---

## 🔗 **CURRENT CONFIGURATION**

**Both are currently pointing to:**
```
Backend: http://localhost:8080
Database: H2 (in-memory) - Same instance
WebSocket: ws://localhost:8080/ws
```

**Test Accounts (Work on BOTH app and website):**
```
Admin: admin@theglitch.com / admin123
User: user@theglitch.com / user123
Premium: premium@theglitch.com / premium123
```

---

**🎉 Your accounts are FULLY SYNCHRONIZED across app and website!** 

**Everything works seamlessly on both platforms!** 🚀

