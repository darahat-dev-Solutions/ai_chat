---

### 6. **`docs/modules/auth_module.md`**

````markdown
# Auth Module

The **Auth Module** provides functionality for:

- User Sign In
- User Sign Up
- Forgot Password
- Social Login

## Directory Structure

- **presentation/**: UI layer – contains all visual components such as pages, widgets, forms (e.g., login, sign-up).
- **domain/**: Core business logic – includes entities (e.g., UserModel), validation rules, and possibly interfaces (abstract classes) that define contracts.
- **infrastructure/**: External data source layer – implements data fetching logic such as API integrations, local storage (Hive/SharedPreferences), Firebase, etc.
- **application/**: Application logic – includes controllers (like Riverpod StateNotifiers), use cases, and acts as the glue between UI (presentation) and data sources (infrastructure).

## Usage

### Sign In

Use the `AuthController` to manage user sign-in logic.

Example:

```dart
AuthController.signIn(email, password);
```
**Github Authentication Setup process**
Certainly. Below is a complete and professional documentation for your **GitHub Authentication Setup in Flutter (Firebase)**, tailored for your project.

---

# 📘 GitHub Authentication Setup – Flutter + Firebase

This document outlines the complete process of integrating **GitHub Sign-In** in a Flutter application using **Firebase Authentication**.

---

## ✅ Prerequisites

Before beginning, ensure the following:

- A Firebase project is set up
- Firebase Auth is enabled for the project
- Flutter SDK is properly installed
- Your app is connected to Firebase using `firebase_core` and `firebase_auth`
- You have a GitHub account

---

## ⚙️ Step 1: Configure GitHub Provider in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Navigate to your project → **Authentication** → **Sign-in method**
3. Enable **GitHub** and provide:

   - **Client ID**
   - **Client Secret**

4. **Save** the changes

---

## 🔑 Step 2: Create GitHub OAuth App

1. Visit: [https://github.com/settings/developers](https://github.com/settings/developers)
2. Click **"New OAuth App"**
3. Fill out the form:

   - **Application Name**: Your app name
   - **Homepage URL**:

     ```
     https://flutter-starter-kit-3bd18.firebaseapp.com
     ```

   - **Authorization Callback URL**:

     ```
     https://flutter-starter-kit-3bd18.firebaseapp.com/__/auth/handler
     ```

4. Save the **Client ID** and **Client Secret**
5. Use these values in Firebase Authentication GitHub provider setup

---

## 🧾 Step 3: Android Manifest Configuration

Open `android/app/src/main/AndroidManifest.xml` and add the following `intent-filter` inside the `<activity>` block:

```xml
<intent-filter android:label="GitHubAuth">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="flutter-starter-kit-3bd18.firebaseapp.com"
        android:path="/__/auth/handler" />
</intent-filter>
```

✅ This allows your Android app to handle GitHub OAuth redirect responses from Firebase.

---

## 🔐 Step 4: Implement GitHub Auth Logic

### `auth_repository.dart`

```dart
Future<UserModel?> signInWithGithub() async {
  try {
    final githubAuthProvider = GithubAuthProvider();
    UserCredential cred;

    if (kIsWeb) {
      // For web platform
      cred = await _auth.signInWithPopup(githubAuthProvider);
    } else {
      // For Android/iOS using built-in provider (Firebase handles redirect)
      cred = await _auth.signInWithProvider(githubAuthProvider);
    }

    return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
  } catch (e) {
    print('Error during github sign-in: $e');
    return null;
  }
}
```

### `auth_controller.dart`

```dart
Future<void> signInWithGithub() async {
  state = const AuthLoading();
  try {
    final user = await _authRepository.signInWithGithub();
    if (user != null) {
      _box.put('user', user);
      state = Authenticated(user);
    } else {
      state = const AuthError('Github Sign in failed. Please try again');
    }
  } catch (e) {
    state = AuthError(e.toString());
  }
}
```

---

## ✅ Step 5: Trigger Sign-In from UI

```dart
ElevatedButton(
  onPressed: () {
    ref.read(authControllerProvider.notifier).signInWithGithub();
  },
  child: Text("Sign in with GitHub"),
)
```

---

## 🧪 Step 6: Test the Flow

1. Run the app on a real Android device or emulator
2. Click “Sign in with GitHub”
3. GitHub login page opens in the browser
4. After successful login, user is redirected back to the app
5. Firebase authenticates the GitHub user and returns a `UserCredential`

---

## 📝 Summary

| Configuration        | Value                                                                         |
| -------------------- | ----------------------------------------------------------------------------- |
| Firebase GitHub Auth | Enabled with Client ID & Secret                                               |
| GitHub OAuth App     | Callback: `https://flutter-starter-kit-3bd18.firebaseapp.com/__/auth/handler` |
| AndroidManifest      | Handles OAuth redirect URI                                                    |
| Dart Code            | Uses `GithubAuthProvider` via `signInWithProvider()`                          |
| Platform             | Supports **Android**, **Web** (via `signInWithPopup`)                         |

---

## 📌 Notes

- This setup uses **Firebase’s redirect handler** and does **not require custom redirect schemes** (`myapp://...`)
- This method **does not require `flutter_web_auth_2`** or backend token exchange
- Works cleanly across Web and Android

---

```

```
