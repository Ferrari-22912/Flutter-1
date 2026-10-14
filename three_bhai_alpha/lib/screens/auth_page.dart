import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:three_bhai/core/config/app_config.dart';
import 'package:three_bhai/core/theme/app_colors.dart';
import 'package:three_bhai/core/utils/validators.dart';
import 'package:three_bhai/core/widgets/gradient_button.dart';
import 'package:three_bhai/controllers/auth_controller.dart';
import 'package:three_bhai/controllers/auth_state.dart';
import 'package:three_bhai/widgets/auth_text_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.onAuthenticated});

  /// Called once after a successful login or registration.
  final VoidCallback onAuthenticated;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _isLogin = true;

  late final Worker _stateWorker;

  @override
  void initState() {
    super.initState();
    _stateWorker = ever<AuthState>(Get.find<AuthController>().observable, (
      state,
    ) {
      if (!mounted) return;

      if (state is AuthFailure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is AuthSuccess) {
        widget.onAuthenticated();
      }
    });
  }

  @override
  void dispose() {
    _stateWorker.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _setMode(bool login) {
    if (_isLogin == login || Get.find<AuthController>().state is AuthLoading) {
      return;
    }
    setState(() => _isLogin = login);
  }

  void _fillDemo() {
    setState(() => _isLogin = true);
    _email.text = AppConfig.demoEmail;
    _password.text = AppConfig.demoPassword;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final controller = Get.find<AuthController>();
    if (_isLogin) {
      controller.signIn(email: _email.text.trim(), password: _password.text);
    } else {
      controller.signUp(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = Get.find<AuthController>().state;
      final isLoading = state is AuthLoading;
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.brandGradient),
          child: Stack(
            children: [
              const Positioned(top: -80, right: -60, child: _GlowCircle(260)),
              const Positioned(
                bottom: -110,
                left: -90,
                child: _GlowCircle(320),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _Brand(),
                          const SizedBox(height: 28),
                          _buildCard(context, isLoading),
                          if (AppConfig.useMockData)
                            _DemoBanner(onFill: _fillDemo),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard(BuildContext context, bool isLoading) {
    final text = Theme.of(context).textTheme;
    final enabled = !isLoading;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ModeToggle(isLogin: _isLogin, onChanged: _setMode),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _isLogin ? 'Welcome back' : 'Create your account',
                key: ValueKey(_isLogin),
                style: text.headlineSmall,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isLogin
                  ? 'Log in to see what you can cook tonight.'
                  : 'Save recipes and pick up where you left off.',
              style: text.bodyMedium?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_isLogin) ...[
                    AuthTextField(
                      controller: _name,
                      label: 'Full name',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      enabled: enabled,
                      validator: Validators.name,
                      autofillHints: const [AutofillHints.name],
                    ),
                    const SizedBox(height: 14),
                  ],
                  AuthTextField(
                    controller: _email,
                    label: 'Email',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    enabled: enabled,
                    validator: Validators.email,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _password,
                    label: 'Password',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    enabled: enabled,
                    textInputAction:
                        _isLogin ? TextInputAction.done : TextInputAction.next,
                    onSubmitted: _isLogin ? _submit : null,
                    validator: _isLogin
                        ? (v) =>
                            Validators.requiredField(v, 'Enter your password')
                        : Validators.newPassword,
                    autofillHints: [
                      _isLogin
                          ? AutofillHints.password
                          : AutofillHints.newPassword,
                    ],
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _confirm,
                      label: 'Confirm password',
                      icon: Icons.lock_reset_rounded,
                      isPassword: true,
                      enabled: enabled,
                      textInputAction: TextInputAction.done,
                      onSubmitted: _submit,
                      validator: Validators.confirmPassword(
                        () => _password.text,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: _isLogin ? 'Log in' : 'Create account',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              'assets/images/logo.png',
              width: 112,
              height: 112,
              semanticLabel: '3Bhai logo: three brothers in chef hats',
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text('3Bhai', style: text.displaySmall?.copyWith(color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          'Three brothers. One kitchen. Zero food waste.',
          textAlign: TextAlign.center,
          style: text.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner({required this.onFill});

  final VoidCallback onFill;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Material(
          color: Colors.black.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onFill,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'ALPHA BUILD: sample data, works offline',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Demo login: ${AppConfig.demoEmail} / ${AppConfig.demoPassword}\n'
                    'Tap here to fill it in',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle(this.size);
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
      );
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.isLogin, required this.onChanged});

  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              label: 'Log in',
              selected: isLogin,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleItem(
              label: 'Sign up',
              selected: !isLogin,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? AppColors.brandGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.muted,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
