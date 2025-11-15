# AI Chat Flutter Project

A Flutter-based chat application with AI integration.

## Getting Started: Your First Steps

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

### 4. Add AI Provider API Key

The application uses Custom LLM via OpenRouter for its AI chat features. For detailed steps on how to obtain your API key, refer to [How to Get Your OpenRouter AI API Key](docs/openrouter_api_key.md).

1.  Create a file named `.env` in the root of the project.
2.  Add your OpenRouter API key to the `.env` file as follows:

    ```
    AI_API_KEY='your_api_key_here'
    ```

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
