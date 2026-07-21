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
  String _selectedRole = 'admin';
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
        context.go(AppRoutes.dashboard);
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
                  // Industrial Corporate Header
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
                  const SizedBox(width: 0, height: 28),
                  const Divider(color: AppColors.borderLight),
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

                  // Role Selection Switcher
                  const Text('Select Enterprise Access Role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondarySlate)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'admin', child: Text('System Administrator')),
                      DropdownMenuItem(value: 'plant_manager', child: Text('Plant Operations Manager')),
                      DropdownMenuItem(value: 'supervisor', child: Text('Production Supervisor')),
                      DropdownMenuItem(value: 'quality_inspector', child: Text('Quality Control Inspector')),
                      DropdownMenuItem(value: 'maintenance_tech', child: Text('Maintenance Engineer')),
                      DropdownMenuItem(value: 'weaver_operator', child: Text('Loom Weaver / Operator')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRole = val);
                    },
                  ),
                  const SizedBox(height: 16),

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
                      if (val == null || val.isEmpty) return 'Please enter corporate email';
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
                  const SizedBox(height: 12),

                  // Remember me & Forgot Password
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
                            const SnackBar(content: Text('Password reset instructions sent to system administrator.')),
                          );
                        },
                        child: const Text('Forgot Password?', style: TextStyle(fontSize: 13, color: AppColors.primaryBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

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
                          : const Text('SIGN IN TO FACTORY SYSTEM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Protected by TexMill Enterprise Security Standards • TLS 1.3',
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
