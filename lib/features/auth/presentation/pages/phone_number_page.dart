import 'package:ai_chat/core/widgets/scaffold_messenger.dart';
import 'package:ai_chat/features/auth/application/auth_controller.dart';
import 'package:ai_chat/features/auth/application/auth_state.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Input PhoneNumber for OTP authentication page
class PhoneNumberPage extends ConsumerStatefulWidget {
  /// Phone Number input page controller
  const PhoneNumberPage({super.key});

  @override
  ConsumerState<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends ConsumerState<PhoneNumberPage> {
  final phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedCountryCode = '+1';
  String? _selectedCountryName = 'United States';

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void _handleBackButton(BuildContext context) {
    // Check if we can pop, if not, go to a fallback route
    if (context.canPop()) {
      context.pop();
    } else {
      // Navigate to login page or home page as fallback
      context.go('/login');
    }
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
      if (next is OTPSent) {
        context.go('/otp');
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
          onPressed: () => _handleBackButton(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.enterPhoneNumber,
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

                  // Phone input section
                  _buildPhoneInputSection(
                    context,
                    controller,
                    isLoading,
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

  Widget _buildHeaderSection(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.enterYourPhoneNumber,
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.weWillSendYouAVerificationCode,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection(
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Country code and phone number input
            _buildPhoneInput(context, colorScheme, textTheme),
            const SizedBox(height: 32),

            // Send OTP button
            _buildSendOTPButton(
              context,
              controller,
              isLoading,
              textTheme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.phoneNumber,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Country code selector
            _buildCountryCodeSelector(context, colorScheme, textTheme),
            const SizedBox(width: 12),

            // Phone number input
            Expanded(
              child: TextFormField(
                controller: phoneNumberController,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: '123 456 7890',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  errorStyle: TextStyle(
                    color: colorScheme.error,
                    fontSize: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .pleaseEnterYourPhoneNumber;
                  }
                  // Basic phone number validation
                  if (value.length < 7) {
                    return "Please enter the valid number";
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                autocorrect: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountryCodeSelector(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: true,
          countryListTheme: CountryListThemeData(
            flagSize: 24,
            backgroundColor: colorScheme.surface,
            textStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            borderRadius: BorderRadius.circular(12),
            inputDecoration: InputDecoration(
              labelText: 'Search',
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          onSelect: (Country country) {
            setState(() {
              _selectedCountryCode = '+${country.phoneCode}';
              _selectedCountryName = country.name;
            });
          },
        );
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedCountryCode ?? '+1',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendOTPButton(
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
        onPressed: isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  final phoneNumber =
                      '$_selectedCountryCode${phoneNumberController.text.trim()}';
                  controller.sendOTP(phoneNumber);
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
                AppLocalizations.of(context)!.sendOTP,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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
                'Sending OTP...',
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
