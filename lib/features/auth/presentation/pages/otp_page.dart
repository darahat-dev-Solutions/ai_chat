import 'dart:async';

import 'package:ai_chat/core/widgets/scaffold_messenger.dart';
import 'package:ai_chat/features/auth/application/auth_controller.dart';
import 'package:ai_chat/features/auth/application/auth_state.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

/// Input OTP Presentation page
class OTPPage extends ConsumerStatefulWidget {
  /// input OTP presentation page controller
  const OTPPage({super.key});

  @override
  ConsumerState<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  final pinController = TextEditingController();
  Timer? _timer;
  int _start = 240; // 4 minutes
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get _formattedTime {
    final minutes = _start ~/ 60;
    final seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoading;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthError) {
        scaffoldMessenger(context, next);
      }
      if (next is Authenticated) {
        context.go('/home', extra: {'title': 'Home'});
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.enterOTP,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground,
          ),
        ),
      ),
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

                  // Header section
                  _buildHeaderSection(context, textTheme, colorScheme),

                  const SizedBox(height: 40),

                  // OTP input section
                  _buildOTPSection(
                    context,
                    controller,
                    isLoading,
                    theme,
                    colorScheme,
                    textTheme,
                  ),

                  // Timer and resend section
                  _buildResendSection(
                    context,
                    controller,
                    theme,
                    colorScheme,
                    textTheme,
                  ),

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
      left: -50,
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

  Widget _buildHeaderSection(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.enterOTP,
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.enterTheOTPSentToYourPhone,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '📱 +1 234 567 8900', // Replace with actual phone number from your state
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOTPSection(
    BuildContext context,
    AuthController controller,
    bool isLoading,
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
      child: Column(
        children: [
          // OTP Input
          _buildOTPInput(theme, colorScheme, controller),
          const SizedBox(height: 32),

          // Verify Button
          _buildVerifyButton(
            context,
            controller,
            isLoading,
            textTheme,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildOTPInput(
    ThemeData theme,
    ColorScheme colorScheme,
    AuthController controller,
  ) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: theme.textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.2),
          width: 1,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: colorScheme.primary,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.primary.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: colorScheme.primary.withOpacity(0.05),
      border: Border.all(
        color: colorScheme.primary,
        width: 2,
      ),
    );

    return Pinput(
      controller: pinController,
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) {
        if (!_isResendEnabled) {
          controller.verifyOTP(pin);
        }
      },
    );
  }

  Widget _buildVerifyButton(
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
        onPressed: isLoading || _isResendEnabled
            ? null
            : () {
                if (pinController.text.length == 6) {
                  controller.verifyOTP(pinController.text);
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
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.verifyOTP,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildResendSection(
    BuildContext context,
    AuthController controller,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            if (!_isResendEnabled)
              Text(
                '${AppLocalizations.of(context)!.resendOTPIn} $_formattedTime',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            if (_isResendEnabled)
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    controller.resendOTP();
                    setState(() {
                      _start = 240;
                    });
                    startTimer();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colorScheme.primary,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.resendOTP,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate back to phone number entry
                context.pop();
              },
              child: Text(
                "Change Phone Number",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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
                'Verifying OTP...',
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
