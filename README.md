# AI Chat Flutter Project

<<<<<<< HEAD
A Flutter-based chat application with AI integration.

## Getting Started: Your First Steps
=======
A feature-rich Flutter-based chat application with AI integration, user-to-user messaging, and Firebase backend support. This app demonstrates modern Flutter development practices including Riverpod state management, clean architecture, and Firebase integration.

## ✨ Features

- 🤖 **AI Chat** - Chat with AI powered by OpenRouter LLM
- 👥 **User-to-User Chat** - Real-time messaging between users
- 🔐 **Authentication** - Google Sign-In and OTP-based authentication with Firebase
- 🔔 **Push Notifications** - Real-time notifications via Firebase Cloud Messaging
- 🌍 **Multi-Language Support** - English, Khmer, Japanese, and Spanish
- 🎨 **Theme Support** - Light and dark theme modes
- 📱 **Responsive Design** - Works seamlessly on Android and iOS
- 💾 **Local Storage** - Task management with local persistence using Hive

## 🛠 Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** Riverpod
- **Backend:** Firebase (Authentication, Firestore, Cloud Messaging)
- **API Client:** Dio
- **Local Database:** Hive
- **LLM Integration:** OpenRouter API
- **Code Generation:** Freezed, JsonSerializable

## 📋 Prerequisites

Before you begin, ensure you have:

- **Flutter SDK** (3.0+) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **Xcode** (for emulator/device)
- **Firebase Account** - [Create at Firebase Console](https://console.firebase.google.com)
- **Git** - For cloning the repository

### Verify Installation

```bash
flutter --version
dart --version
```

## 🚀 Getting Started: Your First Steps
>>>>>>> 7d9fef6f29f2a57f4f5db38905d5c8924ec4ab30

This guide will walk you through setting up and running the project. Follow these steps carefully, and you'll have the app running in no time!

### 1. Clone the Repository

First, get the project files onto your computer.

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Clean Up & Get Dependencies

It's always a good idea to start with a clean slate and fetch all necessary packages.

```bash
flutter clean
flutter pub get
```

### 3. Set Up Firebase: The Backend Power

This project uses Firebase for authentication, database, and other services. You'll need to connect your app to your own Firebase project.

#### 3.1. Create Your Firebase Project

1.  Go to the [Firebase console](https://console.firebase.google.com/).
2.  Click "Add project" and follow the on-screen instructions to create a new project.

#### 3.2. Connect Your Android App to Firebase

This is crucial for features like Google Sign-In and push notifications.

1.  **Add an Android App:** In your Firebase project, click the Android icon to add a new Android app.
    - **Package Name:** Enter your app's package name. You can find this in `android/app/build.gradle.kts` (look for `applicationId`).
2.  **Get Your SHA-1 and SHA-256 Keys:** These keys are essential for Google Sign-In and other Firebase services to verify your app's authenticity.

    - **For Windows:**
      Open your terminal and run this command:

      ```bash
      keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
      ```

    - **For macOS and Linux:**
      Open your terminal and run this command:

      ```bash
      keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
      ```

    - After running the command, copy both the `SHA1` and `SHA256` fingerprints from the output.

3.  **Add SHA Keys to Firebase:** In your Firebase project settings, select your Android app, then click "Add fingerprint" and paste your copied SHA-1 and SHA256 keys.
4.  **Download `google-services.json`:** Download the `google-services.json` file from the Firebase console.
5.  **Place `google-services.json`:** Move this downloaded file into the `android/app` directory of your Flutter project.

#### 3.3. Connect Your iOS App to Firebase (Optional, if targeting iOS)

1.  **Add an iOS App:** In your Firebase project, click the iOS icon to add a new iOS app.
2.  **Download `GoogleService-Info.plist`:** Download the `GoogleService-Info.plist` file from the Firebase console.
3.  **Place `GoogleService-Info.plist`:** Move this file into the `ios/Runner` directory of your Flutter project.

#### 3.4. Deploy Firestore Rules (If you modify them)

If you make changes to your Firestore security rules (`firestore.rules`), you'll need to deploy them.

```bash
firebase deploy --only firestore:rules --project <your-firebase-project-id>
```

_Replace `<your-firebase-project-id>` with your actual Firebase project ID._

<<<<<<< HEAD
### 4. Add AI Provider API Key

The application uses Custom LLM via OpenRouter for its AI chat features. For detailed steps on how to obtain your API key, refer to [How to Get Your OpenRouter AI API Key](docs/openrouter_api_key.md).

1.  Create a file named `.env` in the root of the project.
2.  Add your OpenRouter API key to the `.env` file as follows:

    ```
    AI_API_KEY='your_api_key_here'
    ```
=======
### 4. Configure Environment Variables

This project requires several API keys and configuration values. These are stored in a `.env` file which is **not** included in the repository for security reasons.

#### 4.1. Create Your `.env` File

1. Copy the example file to create your own:

   ```bash
   cp .env.example .env
   ```

2. Edit the `.env` file and replace all placeholder values with your actual credentials:

   ```dotenv
   # LLM Configuration (Required for AI features)
   AI_API_KEY=your_actual_api_key_here
   CUSTOM_LLM_ENDPOINT=https://your-custom-llm-endpoint.com/api/v1/chat/completions
   CUSTOM_LLM_model=your_model_name
   BASE_API_URL=https://your-backend-api-url.com

   # Firebase Configuration (Required)
   FIREBASE_PROJECT_ID=your_firebase_project_id
   FIREBASE_API_KEY=your_firebase_api_key
   FIREBASE_APP_ID=your_firebase_app_id
   FIREBASE_MESSAGING_SENDER_ID=your_firebase_sender_id
   FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket
   FIREBASE_ANDROID_CLIENT_ID=your_android_client_id
   FIREBASE_IOS_CLIENT_ID=your_ios_client_id
   FIREBASE_IOS_BUNDLE_ID=your_ios_bundle_id
   ```

#### 4.2. Get Your API Keys

- **AI_API_KEY & CUSTOM_LLM Settings:** For OpenRouter LLM integration, see [How to Get Your OpenRouter AI API Key](docs/openrouter_api_key.md)
- **Firebase Configuration:** Get these from your Firebase project settings
- **Backend API URL:** Use your own backend API endpoint (or a development server URL)
>>>>>>> 7d9fef6f29f2a57f4f5db38905d5c8924ec4ab30

### 5. Generate Code (Build Runner)

This project uses code generation. You need to run the build runner to generate necessary files.

```bash
flutter run build_runner
```

### 6. Run the Application

Finally, launch the application!

```bash
flutter run
```
<<<<<<< HEAD
=======

## 📁 Project Structure

```
lib/
├── app.dart                 # Main app configuration
├── main.dart                # Entry point
├── firebase_options.dart    # Firebase configuration
├── core/
│   ├── api/                 # API client setup (Dio)
│   ├── config/              # Environment configuration
│   ├── services/            # Services (Firebase, Sound, etc.)
│   ├── utils/               # Utility functions
│   ├── widgets/             # Reusable widgets
│   └── errors/              # Error handling
├── features/
│   ├── ai_chat/             # AI Chat feature
│   ├── utou_chat/           # User-to-User Chat feature
│   ├── auth/                # Authentication feature
│   ├── home/                # Home/Dashboard feature
│   ├── tasks/               # Task management feature
│   ├── app_settings/        # App settings & preferences
│   └── user/                # User profile feature
├── l10n/                    # Localization files
└── app/
    ├── router.dart          # Route configuration
    └── theme/               # Theme configuration
```

## 🔧 Troubleshooting

### Build Issues

#### `MissingPluginException`

**Problem:** Plugin not initialized  
**Solution:** Run `flutter clean` and `flutter pub get`

#### `Firebase Configuration Error`

**Problem:** `google-services.json` not found  
**Solution:** Ensure `google-services.json` is placed in `android/app/` directory

#### `Build Cache Issues`

**Problem:** Strange compilation errors  
**Solution:** Clean everything:

```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
```

### Runtime Errors

#### `Invalid BASE_API_URL`

**Problem:** `BaseUrl must be a valid URL`  
**Solution:** Check `.env` file has a valid `BASE_API_URL` value

#### `FocusNode Disposed Error`

**Problem:** `FocusScopeNode` already disposed  
**Solution:** Update to the latest version of the app (we've fixed this)

### Firebase Issues

- **No notifications?** Ensure Firebase Cloud Messaging is enabled in your Firebase Console
- **Auth not working?** Check SHA-1 and SHA-256 keys are correctly added to Firebase
- **Firestore errors?** Verify firestore rules are deployed: `firebase deploy --only firestore:rules`

## 📚 Documentation

For more detailed information, check out our documentation:

- [Getting Started Guide](docs/getting_started.md)
- [Firebase Setup Guide](docs/firebase_firestore.md)
- [Localization Setup](docs/localization_setup.md)
- [Notification Integration](docs/impl_notification_feature.md)
- [OpenRouter API Key Setup](docs/openrouter_api_key.md)
- [Best Practices](docs/best_practices.md)
- [Project Structure Details](docs/project_structure.md)

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows the [Best Practices](docs/best_practices.md) guide.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Support

For issues, feature requests, or questions:

- Open an [GitHub Issue](https://github.com/darahat-dev-Solutions/ai_chat/issues)
- Check existing [documentation](docs/)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- OpenRouter for LLM integration
- All our contributors and supporters

---

## Happy Coding! 🚀
>>>>>>> 7d9fef6f29f2a57f4f5db38905d5c8924ec4ab30
