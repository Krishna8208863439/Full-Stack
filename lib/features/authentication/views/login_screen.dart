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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;

    return Scaffold(
      backgroundColor: AppColors.surfaceVariantLight,
      body: isDesktop
          ? Row(
              children: [
                // Desktop Split Left Graphic Banner Panel
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.surfaceDark,
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.precision_manufacturing, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'TEXMILL ERP',
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enterprise Weaving Mill Execution Platform',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Real-time airjet & rapier loom telemetry, yarn cone tare-weight reconciliation, ASTM D5430 4-point quality grading, and shift workforce management.',
                              style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7), height: 1.6),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                _brandingMetric('48', 'ACTIVE LOOMS'),
                                const SizedBox(width: 24),
                                _brandingMetric('88.4%', 'PLANT EFFICIENCY'),
                                const SizedBox(width: 24),
                                _brandingMetric('14.2K m', 'DAILY OUTPUT'),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '© 2026 TexMill ERP • Enterprise Multi-Platform Release',
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                ),
                // Desktop Split Right Form Panel
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: _buildLoginForm(authState),
                      ),
                    ),
                  ),
                ),
              ],
            )
          // Mobile & Tablet Centered Card Login
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  padding: const EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: _buildLoginForm(authState),
                ),
              ),
            ),
    );
  }

  Widget _brandingMetric(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildLoginForm(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.precision_manufacturing, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TEXMILL ERP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 1)),
                  Text('Weaving Mill Enterprise System', style: TextStyle(fontSize: 11, color: AppColors.secondarySlate)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Role Selection (Admin vs Worker)
          const Text('SELECT LOGIN TYPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondarySlate)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(color: AppColors.surfaceVariantLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRole = 'admin'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: _selectedRole == 'admin' ? AppColors.primaryBlue : Colors.transparent, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings, size: 16, color: _selectedRole == 'admin' ? Colors.white : AppColors.secondarySlate),
                          const SizedBox(width: 6),
                          Text('Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _selectedRole == 'admin' ? Colors.white : AppColors.textDark)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRole = 'worker'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: _selectedRole == 'worker' ? AppColors.primaryBlue : Colors.transparent, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.badge, size: 16, color: _selectedRole == 'worker' ? Colors.white : AppColors.secondarySlate),
                          const SizedBox(width: 6),
                          Text('Worker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _selectedRole == 'worker' ? Colors.white : AppColors.textDark)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (authState.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.statusDanger.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.statusDanger)),
              child: Text(authState.errorMessage!, style: const TextStyle(color: AppColors.statusDanger, fontSize: 12)),
            ),
            const SizedBox(height: 12),
          ],

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email / Employee ID', prefixIcon: const Icon(Icons.email_outlined, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
            validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline, size: 18),
              suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: _rememberMe, activeColor: AppColors.primaryBlue, onChanged: (v) => setState(() => _rememberMe = v ?? true)),
                  const Text('Remember Me', style: TextStyle(fontSize: 12)),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?', style: TextStyle(fontSize: 12, color: AppColors.primaryBlue)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: authState.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
              child: authState.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('SIGN IN AS ${_selectedRole.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: authState.isLoading ? null : _handleGoogleLogin,
            icon: const Icon(Icons.g_mobiledata, size: 24, color: AppColors.primaryBlue),
            label: Text('Continue with Google ($_selectedRole)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textDark)),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10), side: const BorderSide(color: AppColors.borderLight), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          ),
        ],
      ),
    );
  }
}
