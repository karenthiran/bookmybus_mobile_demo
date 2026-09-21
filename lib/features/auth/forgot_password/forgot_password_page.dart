import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../login/widgets/auth_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  bool _submitted = false;

  String? get _emailError {
    if (!_submitted) return null;
    final v = _email.text.trim();
    if (v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(v)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void _onSend() {
    setState(() => _submitted = true);
    if (_emailError != null) return;

    // TODO: ADD BACKEND CODE HERE
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 768;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 0 : AppSpacing.lg,
            vertical: AppSpacing.xxxl,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──────────────────────────────────────────────
                Text('Forgot your password?', style: tt.headlineMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "Enter your email address and we'll send you a secure link to reset your password.",
                  style: tt.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Card ─────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email
                      const AuthFieldLabel('Email address'),
                      AuthFormField(
                        controller: _email,
                        hint: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icons.email_outlined,
                        errorText: _emailError,
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Helper text
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 13,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              'Use the email linked with your BookMyBus account.',
                              style: tt.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Send button
                      FilledButton(
                        onPressed: _onSend,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: const Text(
                          'Send reset link',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Back to login
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            'Back to login',
                            style: tt.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Need help
                Center(
                  child: Text(
                    'Need help? ',
                    style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: ADD BACKEND CODE HERE
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Contact our support team.',
                      style: tt.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
