# iOS Build Guide - THE GLITCH App

## 🚨 Important: Building iOS on Windows

**You cannot build iOS apps directly on Windows.** However, you have several cloud-based solutions.

---

## ✅ Method 1: GitHub Actions (Recommended - FREE)

### Already Set Up! ✅

I've added a GitHub Actions workflow that builds your iOS app automatically.

### How to Use:

1. **Go to GitHub Repository**:
   ```
   https://github.com/Shubz69/theglitchapp
   ```

2. **Navigate to Actions Tab**:
   - Click "Actions" at the top
   - Click "Build iOS App" on the left

3. **Run the Build**:
   - Click "Run workflow" (green button)
   - Select branch: `main`
   - Click "Run workflow"

4. **Wait for Build** (3-5 minutes):
   - Watch the progress
   - Green checkmark ✅ = Success

5. **Download IPA**:
   - Click on the completed workflow
   - Scroll to "Artifacts" section
   - Download "ios-app"
   - Unzip to get `the_glitch_app.ipa`

---

## 📱 Method 2: Install on iPhone Using AltStore (No Mac Required!)

### Setup AltStore on Windows:

1. **Download AltStore**:
   - Go to https://altstore.io/
   - Download for Windows
   - Install AltServer

2. **Install AltStore on iPhone**:
   - Connect iPhone to PC via USB cable
   - Make sure iTunes is installed (even if you don't use it)
   - Click AltServer icon in Windows system tray (bottom right)
   - Click "Install AltStore"
   - Select your iPhone
   - Enter Apple ID and password
   - AltStore app will appear on your iPhone

3. **Trust AltStore**:
   - iPhone Settings → General → VPN & Device Management
   - Tap your Apple ID
   - Tap "Trust"

### Install THE GLITCH App:

1. **Transfer IPA to iPhone**:
   - Email the IPA to yourself
   - Or use AirDrop
   - Or upload to iCloud Drive

2. **Install via AltStore**:
   - Open the IPA file on iPhone
   - Select "Open in AltStore"
   - Tap "Install"
   - Wait for installation

3. **Trust the App**:
   - Settings → General → VPN & Device Management
   - Trust your developer certificate

4. **Launch the App**:
   - Find THE GLITCH icon on home screen
   - Tap to open!

### ⚠️ Important Notes:
- Apps installed via AltStore expire after 7 days
- You need to refresh them weekly using AltStore
- Keep AltServer running on your PC when refreshing

---

## 🌟 Method 3: Codemagic (Professional Cloud Build)

### Setup:

1. **Sign Up**:
   ```
   https://codemagic.io/signup
   ```
   Free tier: 500 build minutes/month

2. **Add Repository**:
   - Click "Add application"
   - Connect to GitHub
   - Select `Shubz69/theglitchapp`

3. **Configure Build**:
   - Select "Flutter App"
   - Choose iOS platform
   - Select "Automatic" configuration

4. **Start Build**:
   - Click "Start new build"
   - Wait 5-10 minutes

5. **Download & Install**:
   - Codemagic provides download link
   - Can generate install link for iPhone
   - Open link on iPhone to install directly!

### Advantages:
- ✅ Professional build environment
- ✅ Direct install links
- ✅ Build logs and debugging
- ✅ Can connect Apple Developer account
- ✅ Automatic TestFlight uploads

---

## 🍎 Method 4: TestFlight (Official Apple Distribution)

### Requirements:
- Apple Developer Account ($99/year)
- Mac computer (or cloud Mac service)

### Steps:

1. **Get Apple Developer Account**:
   ```
   https://developer.apple.com/programs/
   ```
   Cost: $99/year

2. **Create App in App Store Connect**:
   - Go to https://appstoreconnect.apple.com/
   - Create new app
   - Fill in app information

3. **Build on Mac** (or use Codemagic):
   - Archive the app
   - Upload to App Store Connect

4. **Add to TestFlight**:
   - Enable TestFlight in App Store Connect
   - Add your iPhone as test device

5. **Install on iPhone**:
   - Download TestFlight app from App Store
   - Open invitation link
   - Install THE GLITCH app

### Advantages:
- ✅ Official Apple distribution
- ✅ Up to 100 testers
- ✅ No 7-day expiration
- ✅ Prepare for App Store release

---

## 🖥️ Method 5: Cloud Mac Services

### If you need a Mac temporarily:

**MacStadium**:
- Rent Mac in cloud
- $69-99/month
- Full macOS access
- https://www.macstadium.com/

**MacinCloud**:
- Pay-as-you-go
- $1/hour or $20/month
- https://www.macincloud.com/

**AWS Mac Instances**:
- Amazon EC2 Mac instances
- Pay per hour
- https://aws.amazon.com/ec2/instance-types/mac/

### How to Use:
1. Rent cloud Mac
2. Install Flutter & Xcode
3. Clone your GitHub repo
4. Build iOS app
5. Connect iPhone and install

---

## 📊 Comparison Table

| Method | Cost | Setup Time | Best For |
|--------|------|------------|----------|
| **GitHub Actions** | FREE | 5 min | Quick builds |
| **AltStore** | FREE | 30 min | Personal testing |
| **Codemagic** | FREE tier | 15 min | Professional builds |
| **TestFlight** | $99/year | 2 hours | Distribution & App Store |
| **Cloud Mac** | $20-99/month | 1 hour | Full development |

---

## 🎯 Recommended Path

### For Testing (Right Now):
1. ✅ Use **GitHub Actions** to build IPA (already set up!)
2. ✅ Use **AltStore** to install on iPhone
3. ✅ Test the app

### For Distribution (Later):
1. Get **Apple Developer Account** ($99/year)
2. Use **Codemagic** for automated builds
3. Upload to **TestFlight**
4. Share with testers
5. Submit to **App Store**

---

## 🚀 Quick Start Checklist

- [ ] Go to GitHub → Actions → Run "Build iOS App"
- [ ] Download IPA file from artifacts
- [ ] Install AltStore on Windows
- [ ] Install AltStore on iPhone
- [ ] Transfer IPA to iPhone
- [ ] Install app via AltStore
- [ ] Trust developer certificate
- [ ] Launch THE GLITCH app!

---

## ❓ Troubleshooting

**Build fails on GitHub Actions**:
- Check the build logs in Actions tab
- Make sure all dependencies are correct
- May need to adjust iOS version in `ios/Podfile`

**AltStore can't find iPhone**:
- Make sure iPhone is connected via USB
- Trust computer on iPhone
- Restart AltServer
- Make sure iTunes is installed

**App won't install**:
- Check iOS version (needs iOS 12+)
- Make sure you have storage space
- Try restarting iPhone

**App crashes on launch**:
- Check if all permissions are granted
- May need to rebuild with proper signing
- Check crash logs in Xcode (if you have Mac access)

---

## 📞 Need Help?

- GitHub Issues: https://github.com/Shubz69/theglitchapp/issues
- AltStore Discord: https://altstore.io/discord
- Flutter iOS docs: https://flutter.dev/docs/deployment/ios

---

Good luck! 🍀

