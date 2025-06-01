import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/login_request.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive_layout.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final loginRequest = LoginRequest(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(loginRequest);

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context, authProvider),
        desktop: _buildDesktopLayout(context, authProvider),
      ),
    );
  }
  
  Widget _buildMobileLayout(BuildContext context, AuthProvider authProvider) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.shopping_cart,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                'Bienvenido de Nuevo',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildLoginForm(context, authProvider),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDesktopLayout(BuildContext context, AuthProvider authProvider) {
    return Center(
      child: Row(
        children: [
          // Left side - decorative area (1/3 of screen)
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 150,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Aplicación de Comercio Electrónico',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Compra tus productos favoritos desde cualquier dispositivo',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Right side - login form (2/3 of screen)
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Bienvenido de Nuevo',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        _buildLoginForm(context, authProvider),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoginForm(BuildContext context, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Usuario',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu nombre de usuario';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu contraseña';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        if (authProvider.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              authProvider.errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ElevatedButton(
          onPressed: authProvider.loading ? null : _login,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: authProvider.loading
              ? const CircularProgressIndicator()
              : const Text('INICIAR SESIÓN'),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text('¿No tienes una cuenta? Regístrate'),
        ),
      ],
    );
  }
}