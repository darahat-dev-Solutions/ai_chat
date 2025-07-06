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
````
