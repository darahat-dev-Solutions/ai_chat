import 'package:ai_chat/core/widgets/scaffold_messenger.dart';
import 'package:ai_chat/features/auth/application/auth_controller.dart';
import 'package:ai_chat/features/auth/application/auth_state.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/auth_providers.dart';

/// Login Page Presentation
class LoginPage extends ConsumerStatefulWidget {
  /// Login Page Constructor
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthMethod _currentAuthMethod = AuthMethod.none;

  // Animation controllers would be added here for more advanced animations

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoading;
    final obscureText = ref.watch(obscureTextProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthError) {
        _currentAuthMethod = AuthMethod.none;
        scaffoldMessenger(context, next);
      }
      if (next is Authenticated) {
        _currentAuthMethod = AuthMethod.none;
        context.go('/home', extra: {'title': 'Home'});
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements
            _buildBackgroundElements(theme),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Welcome section
                  _buildWelcomeSection(textTheme, colorScheme, context),

                  const SizedBox(height: 40),

                  // Login form
                  _buildLoginForm(
                    context,
                    controller,
                    isLoading,
                    obscureText,
                    theme,
                    colorScheme,
                    textTheme,
                  ),

                  // Social login section
                  _buildSocialLoginSection(
                    context,
                    controller,
                    isLoading,
                    theme,
                    colorScheme,
                    textTheme,
                  ),

                  // Sign up prompt
                  _buildSignUpPrompt(
                      context, isLoading, textTheme, colorScheme),

                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Loading overlay
            if (isLoading) _buildLoadingOverlay(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements(ThemeData theme) {
    return Positioned(
      top: -50,
      right: -50,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(
      TextTheme textTheme, ColorScheme colorScheme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.welcome} Back 👋',
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.signInToContinue,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    AuthController controller,
    bool isLoading,
    bool obscureText,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email field
            _buildEmailField(context, colorScheme, textTheme),
            const SizedBox(height: 20),

            // Password field
            _buildPasswordField(context, obscureText, colorScheme, textTheme),
            const SizedBox(height: 16),

            // Forgot password
            _buildForgotPassword(context, isLoading, textTheme, colorScheme),
            const SizedBox(height: 24),

            // Sign in button
            _buildSignInButton(
                context, controller, isLoading, textTheme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.email,
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterYourEmail;
        }
        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return AppLocalizations.of(context)!.pleaseEnterAValidEmailAddress;
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
    );
  }

  Widget _buildPasswordField(BuildContext context, bool obscureText,
      ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: passwordController,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: () {
            ref.read(obscureTextProvider.notifier).state = !obscureText;
          },
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterYourPassword;
        }
        if (value.length < 6) {
          return AppLocalizations.of(context)!.passwordMustBeAtLeast6Characters;
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword(BuildContext context, bool isLoading,
      TextTheme textTheme, ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: isLoading
            ? null
            : () {
                context.go('/forget_password');
              },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          AppLocalizations.of(context)!.forgotPassword,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(
    BuildContext context,
    AuthController controller,
    bool isLoading,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading && _currentAuthMethod != AuthMethod.email
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _currentAuthMethod = AuthMethod.email;
                  });
                  controller.signIn(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _currentAuthMethod == AuthMethod.email && isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.signIn,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialLoginSection(
    BuildContext context,
    AuthController controller,
    bool isLoading,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        const SizedBox(height: 32),

        // Divider with "or"
        _buildDividerWithOr(context, colorScheme, textTheme),
        const SizedBox(height: 32),

        // Social buttons
        _buildSocialButtons(
            context, controller, isLoading, colorScheme, textTheme),
      ],
    );
  }

  Widget _buildDividerWithOr(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.onSurface.withOpacity(0.2),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.or,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.onSurface.withOpacity(0.2),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(
    BuildContext context,
    AuthController controller,
    bool isLoading,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        // Google button
        _buildSocialButton(
          iconPath: 'assets/icon/google_logo.png',
          text: AppLocalizations.of(context)!.continueWithGoogle,
          isLoading: isLoading && _currentAuthMethod != AuthMethod.google,
          onPressed: () async {
            setState(() {
              _currentAuthMethod = AuthMethod.google;
            });
            await controller.signInWithGoogle();
          },
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 16),

        // Phone button
        _buildSocialButton(
          icon: Icons.phone,
          text: AppLocalizations.of(context)!.continueWithPhone,
          isLoading: isLoading,
          onPressed: () {
            context.go('/phone-number');
          },
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 16),

        // GitHub button
        _buildSocialButton(
          iconPath: 'assets/icon/github_logo.png',
          text: AppLocalizations.of(context)!.continueWithGithub,
          isLoading: isLoading && _currentAuthMethod != AuthMethod.github,
          onPressed: () async {
            setState(() {
              _currentAuthMethod = AuthMethod.github;
            });
            await controller.signInWithGithub();
          },
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    String? iconPath,
    IconData? icon,
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.2),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              Image.asset(
                iconPath,
                height: 24,
                width: 24,
              ),
            if (icon != null)
              Icon(
                icon,
                color: colorScheme.onSurface.withOpacity(0.7),
                size: 24,
              ),
            const SizedBox(width: 12),
            Text(
              text,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt(BuildContext context, bool isLoading,
      TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: TextButton(
          onPressed: isLoading ? null : () => context.go('/register'),
          child: RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.dontHaveAnAccount,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              children: [
                TextSpan(
                  text: ' ${AppLocalizations.of(context)!.signUp}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay(ThemeData theme) {
    return Container(
      color: theme.colorScheme.scrim.withAlpha(100),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Signing in...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
