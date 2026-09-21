import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../forgot_password/forgot_password_page.dart';
import 'widgets/auth_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  // ── Validation ────────────────────────────────────────────────────────────

  String? get _emailError {
    if (!_submitted) return null;
    final v = _email.text.trim();
    if (v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(v)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? get _passwordError {
    if (!_submitted) return null;
    final v = _password.text;
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Must include an uppercase letter';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Must include a lowercase letter';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Must include a number';
    if (!v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'Must include a special character';
    }
    return null;
  }

  bool get _isValid => _emailError == null && _passwordError == null;

  void _onSubmit() {
    setState(() => _submitted = true);
    if (!_isValid) return;

    // TODO: ADD BACKEND CODE HERE
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
                Text('Welcome back', style: tt.headlineMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Manage your company account and buses',
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
                      const AuthFieldLabel('Email Address'),
                      AuthFormField(
                        controller: _email,
                        hint: 'your@email.com',
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icons.email_outlined,
                        errorText: _emailError,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Password
                      const AuthFieldLabel('Password'),
                      AuthFormField(
                        controller: _password,
                        hint: '••••••••',
                        obscureText: _obscurePassword,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        errorText: _passwordError,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Password requirements
                      _PasswordRequirements(password: _password.text),
                      const SizedBox(height: AppSpacing.xl),

                      // Submit button
                      FilledButton(
                        onPressed: _onSubmit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: const Text(
                          'Start Journey',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Forgot password
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          ),
                          child: Text(
                            'Forgot password?',
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
                  child: TextButton(
                    onPressed: () {
                      // TODO: ADD BACKEND CODE HERE
                    },
                    child: Text(
                      'Need help?',
                      style: tt.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
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

// ── Password Requirements ────────────────────────────────────────────────────

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Req('Minimum 8 characters', password.length >= 8),
        _Req('Uppercase letter', password.contains(RegExp(r'[A-Z]'))),
        _Req('Lowercase letter', password.contains(RegExp(r'[a-z]'))),
        _Req('Number', password.contains(RegExp(r'[0-9]'))),
        _Req(
          'Special character',
          password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
        ),
      ],
    );
  }
}

class _Req extends StatelessWidget {
  const _Req(this.label, this.met);

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 14,
            color: met ? AppColors.success : AppColors.textHint,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: met ? AppColors.success : AppColors.textHint,
                ),
          ),
        ],
      ),
    );
  }
}
