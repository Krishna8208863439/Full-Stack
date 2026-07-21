import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@texmill-erp.com');
  final _passwordController = TextEditingController(text: 'password123');
  String _selectedRole = 'admin'; // 'admin' or 'worker'
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
            _selectedRole,
          );
      if (success && mounted) {
        if (_selectedRole == 'admin') {
          context.go(AppRoutes.adminDashboard);
        } else {
          context.go(AppRoutes.workerDashboard);
        }
      }
    }
  }

  void _handleGoogleLogin() async {
    final success = await ref.read(authProvider.notifier).loginWithGoogle(_selectedRole);
    if (success && mounted) {
      if (_selectedRole == 'admin') {
        context.go(AppRoutes.adminDashboard);
      } else {
        context.go(AppRoutes.workerDashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceVariantLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 460),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Industrial Brand Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.precision_manufacturing, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TEXMILL ERP',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'Weaving Mill Enterprise System',
                            style: TextStyle(fontSize: 12, color: AppColors.secondarySlate),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.borderLight),
                  const SizedBox(height: 20),

                  // Role Selection Segmented Bar (Admin vs Worker)
                  const Text(
                    'SELECT LOGIN TYPE',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondarySlate, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'admin'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'admin' ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.admin_panel_settings, size: 18, color: _selectedRole == 'admin' ? Colors.white : AppColors.secondarySlate),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: _selectedRole == 'admin' ? Colors.white : AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'worker'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'worker' ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.badge, size: 18, color: _selectedRole == 'worker' ? Colors.white : AppColors.secondarySlate),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Worker',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: _selectedRole == 'worker' ? Colors.white : AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (authState.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.statusDanger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.statusDanger),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.statusDanger, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: const TextStyle(color: AppColors.statusDanger, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email Input
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Corporate Email / Employee ID',
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Please enter email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Please enter password';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Remember me & Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.primaryBlue,
                            onChanged: (val) => setState(() => _rememberMe = val ?? true),
                          ),
                          const Text('Remember Me', style: TextStyle(fontSize: 13, color: AppColors.textDark)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password reset instructions sent to registered email.')),
                          );
                        },
                        child: const Text('Forgot Password?', style: TextStyle(fontSize: 13, color: AppColors.primaryBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sign In Button
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: authState.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(
                              'SIGN IN AS ${_selectedRole.toUpperCase()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Or Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.borderLight)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR', style: TextStyle(fontSize: 11, color: AppColors.secondarySlate, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Divider(color: AppColors.borderLight)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Google Sign In Button
                  OutlinedButton.icon(
                    onPressed: authState.isLoading ? null : _handleGoogleLogin,
                    icon: const Icon(Icons.g_mobiledata, size: 24, color: AppColors.primaryBlue),
                    label: Text(
                      'Continue with Google ($_selectedRole)',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.borderLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Center(
                    child: Text(
                      'Protected by TexMill Enterprise Auth • TLS 1.3 & Firebase SSO',
                      style: TextStyle(fontSize: 11, color: AppColors.secondarySlate),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
