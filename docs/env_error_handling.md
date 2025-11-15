# Environment Configuration Error Handling

This document explains the gentle and user-friendly error handling system for missing or invalid environment variables in the AI Chat application.

## Overview

Instead of showing harsh red error messages, the app now displays beautiful, informative error screens that guide users through fixing configuration issues.

## Error Handling Features

### 1. **Environment Variable Validation** (`EnvValidator`)

Located in: `lib/core/config/env_validator.dart`

The validator checks for required environment variables on app startup:

- `BASE_API_URL`
- `AI_API_KEY`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_API_KEY`

**Methods:**

```dart
// Check all required variables
final missingVars = EnvValidator.validateEnv();

// Get a single variable with fallback
final apiKey = EnvValidator.getEnv('AI_API_KEY', defaultValue: '');

// Check if a variable is valid
final isValid = EnvValidator.isEnvVarValid('BASE_API_URL');
```

### 2. **Beautiful Error Widget** (`EnvErrorWidget`)

Located in: `lib/core/widgets/env_error_widget.dart`

Displays a friendly error screen with:

- Warning icon with amber styling
- Clear title and subtitle
- List of missing variables
- Step-by-step instructions to fix
- Helpful tips

**Features:**

- Amber/warm color scheme (not harsh red)
- Clear formatting and typography
- Scrollable content for mobile
- Non-technical language
- Actionable guidance

### 3. **Error Banner** (`EnvErrorBanner`)

Located in: `lib/core/widgets/env_error_banner.dart`

A lightweight banner widget for displaying single missing variable errors within the app.

```dart
EnvErrorBanner(
  message: 'Please configure your backend URL',
  variableName: 'BASE_API_URL',
)
```

## How It Works

### Startup Process

1. **App launches** → `main.dart` runs
2. **Load .env file** → Environment variables loaded
3. **Validate** → `EnvValidator.validateEnv()` checks all required variables
4. **If missing:**
   - Show `EnvErrorWidget` with clear instructions
   - User cannot proceed to app
5. **If valid:**
   - Continue normal initialization
   - Run app normally

### Example Error Screen

When `.env` is missing `BASE_API_URL`:

```
┌─────────────────────────────────────────┐
│         ⚠️  Setup Required                │
│                                         │
│  Please configure the missing           │
│  environment variables                  │
│                                         │
│  Missing Variables:                     │
│  • BASE_API_URL (current: YOUR BACKEND) │
│                                         │
│  How to Fix:                            │
│  1. Copy .env.example to .env           │
│  2. Edit .env with actual values        │
│  3. Do not use placeholder values       │
│  4. Restart the app                     │
│                                         │
│  [Retry After Updating .env]            │
└─────────────────────────────────────────┘
```

## Adding More Validation Rules

To add more required environment variables:

### 1. Update `EnvValidator`

```dart
static const List<String> requiredEnvVars = [
  'BASE_API_URL',
  'AI_API_KEY',
  'FIREBASE_PROJECT_ID',
  'FIREBASE_API_KEY',
  'NEW_VARIABLE', // Add here
];
```

### 2. Update `.env.example`

```dotenv
BASE_API_URL=https://your-backend-api-url.com
AI_API_KEY=your_actual_api_key_here
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_API_KEY=your_firebase_api_key
NEW_VARIABLE=your_new_variable_value
```

## Error Messages

Instead of technical errors like:

```
❌ BASE_API_URL is not set or is empty in .env file
```

Users see:

```
⚠️ Setup Required

Missing Variables:
• BASE_API_URL

How to Fix:
1. Copy .env.example to .env
2. Edit .env with your actual values
```

## Color Scheme

- **Warnings/Missing Vars**: Amber (`Colors.amber`)
- **Information**: Blue (`Colors.blue`)
- **Errors**: Red (`Colors.red`)
- **Background**: Light tints (50) for accessibility

## Customization

### Change Error Widget Styling

Edit `lib/core/widgets/env_error_widget.dart`:

```dart
// Change title color
color: Colors.amber[900],  // Modify this

// Change icon
Icons.warning_rounded,     // Or use different icon

// Change button style
backgroundColor: Colors.amber[700],  // Customize
```

### Change Required Variables

Edit `lib/core/config/env_validator.dart`:

```dart
static const List<String> requiredEnvVars = [
  // Add/remove variables as needed
];
```

## Testing Error Handling

To test the error widget:

1. Temporarily break a variable in `.env`
2. Run the app
3. You'll see the friendly error screen
4. Fix the variable and restart

Example:

```dotenv
# Temporarily break this to test
BASE_API_URL=INVALID
```

## FAQ

**Q: What if I want optional variables?**
A: Remove them from `requiredEnvVars` list. They'll be treated as optional.

**Q: Can I use different error messages?**
A: Yes! Customize `EnvErrorWidget` to show different messages based on variable names.

**Q: What about production error handling?**
A: The same system works in production. Users see the same friendly error screen.

**Q: How do I validate app-level errors differently?**
A: Use `EnvErrorBanner` for runtime warnings within the app during normal operation.

## Related Files

- `lib/main.dart` - Startup validation
- `lib/core/api/dio_provider.dart` - API configuration validation
- `lib/core/config/env_validator.dart` - Validation logic
- `.env.example` - Template for users
- `docs/getting_started.md` - Setup guide for users

## Support

If users encounter errors:

1. Check `.env` file exists and is in project root
2. Verify all variables are filled with actual values
3. Check `.env.example` for required variables
4. See [Getting Started Guide](getting_started.md)
