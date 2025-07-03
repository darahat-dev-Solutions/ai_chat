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

- **presentation/**: UI components for login, sign-up forms.
- **domain/**: Auth-related business logic (e.g., validation).
- **data/**: Data sources for authentication (API, local storage).

## Usage

### Sign In

Use the `AuthController` to manage user sign-in logic.

Example:

```dart
AuthController.signIn(email, password);
```
````
