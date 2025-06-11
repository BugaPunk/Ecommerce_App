import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/update_profile_request.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive_layout.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null) {
        print('[DEBUG_LOG] User is null, cannot save profile');
        return;
      }

      print('[DEBUG_LOG] Current user data:');
      print('[DEBUG_LOG] - username: ${user.username}');
      print('[DEBUG_LOG] - email: ${user.email}');
      print('[DEBUG_LOG] - firstName: ${user.firstName}');
      print('[DEBUG_LOG] - lastName: ${user.lastName}');

      print('[DEBUG_LOG] Form data:');
      print('[DEBUG_LOG] - username: ${_usernameController.text.trim()}');
      print('[DEBUG_LOG] - email: ${_emailController.text.trim()}');
      print('[DEBUG_LOG] - firstName: ${_firstNameController.text.trim()}');
      print('[DEBUG_LOG] - lastName: ${_lastNameController.text.trim()}');

      // Check if any field has changed
      final hasChanges = _usernameController.text.trim() != user.username ||
                        _emailController.text.trim() != user.email ||
                        _firstNameController.text.trim() != user.firstName ||
                        _lastNameController.text.trim() != user.lastName;

      print('[DEBUG_LOG] Has changes: $hasChanges');

      if (!hasChanges) {
        print('[DEBUG_LOG] No changes detected, exiting edit mode');
        setState(() {
          _isEditing = false;
        });
        return;
      }

      final updateRequest = UpdateProfileRequest(
        username: _usernameController.text.trim() != user.username 
            ? _usernameController.text.trim() 
            : null,
        email: _emailController.text.trim() != user.email 
            ? _emailController.text.trim() 
            : null,
        firstName: _firstNameController.text.trim() != user.firstName 
            ? _firstNameController.text.trim() 
            : null,
        lastName: _lastNameController.text.trim() != user.lastName 
            ? _lastNameController.text.trim() 
            : null,
      );

      final success = await authProvider.updateProfile(updateRequest);

      if (mounted) {
        if (success) {
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Error al actualizar perfil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
    _loadUserData(); // Reset to original values
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveLayout.builder(
              context: context,
              mobile: _buildMobileLayout(context, authProvider),
              desktop: _buildDesktopLayout(context, authProvider),
            ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(context, authProvider.user!),
          const SizedBox(height: 24),
          _buildProfileForm(context, authProvider),
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AuthProvider authProvider) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Profile header
            Expanded(
              flex: 1,
              child: _buildProfileHeader(context, authProvider.user!),
            ),
            const SizedBox(width: 32),
            // Right side - Form and actions
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildProfileForm(context, authProvider),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '@${user.username}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text(user.roles.join(", ")),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
            
            // Botón especial para vendedores
            if (user.roles.contains('ROLE_VENDEDOR')) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.store,
                      color: Colors.green.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Eres un Vendedor!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/vendor/dashboard');
                      },
                      icon: const Icon(Icons.dashboard),
                      label: const Text('Ir a Mi Dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, AuthProvider authProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información Personal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de Usuario',
                  prefixIcon: Icon(Icons.person),
                ),
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre de usuario es requerido';
                  }
                  if (value.trim().length < 3) {
                    return 'El nombre de usuario debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
                enabled: _isEditing,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El correo electrónico es requerido';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.badge),
                ),
                enabled: _isEditing,
                validator: (value) {
                  if (value != null && value.length > 50) {
                    return 'El nombre no puede exceder 50 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                enabled: _isEditing,
                validator: (value) {
                  if (value != null && value.length > 50) {
                    return 'El apellido no puede exceder 50 caracteres';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isEditing) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Cambios'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _cancelEdit,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.lock),
                label: const Text('Cambiar Contraseña'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed('/orders');
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('Mis Pedidos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
