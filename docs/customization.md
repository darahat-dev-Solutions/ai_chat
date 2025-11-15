Customization Guide

🏷️ Change App Name

Update the pubspec.yaml file:

name: your_app_name

Android: android/app/src/main/AndroidManifest.xml

iOS: ios/Runner/Info.plist

🖼️ Change App Icons & Splash

Use flutter_launcher_icons

Use flutter_native_splash

flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create

🎨 Change Theme & Colors

Go to shared/theme/app_theme.dart

Update color palette, font sizes, padding, radius, etc.

🌐 Change Language / Localization

Modify supported locales in settings_module

Add JSON or ARB files for each language

Use intl or easy_localization package

🧪 Branding Assets

Replace logos in assets/images

Reference in UI through Image.asset('assets/images/logo.png')

📁 Change Package Name

To change the package name of your app, it is highly recommended to use the `change_app_package_name` package. This will ensure all necessary files are updated correctly.

1.  **Run the command:**

    ```bash
    flutter pub run change_app_package_name:main com.new.package.name
    ```

    Replace `com.new.package.name` with your desired package name.

2.  **Manual Changes (if needed):**

    If you prefer to change the package name manually, you will need to update the following files:

    *   **Android:** `android/app/build.gradle` (look for `applicationId`)
    *   **iOS:** `ios/Runner.xcodeproj` (look for `PRODUCT_BUNDLE_IDENTIFIER`)

    **Note:** Manual changes are not recommended as it's easy to miss a required change, which can cause build issues.

🧭 Best Practices

Use Riverpod for scalable, testable state management

Keep features decoupled and reusable

Reuse shared widgets across features

Use core/errors for global error handling

Create use_cases and repositories to separate logic
