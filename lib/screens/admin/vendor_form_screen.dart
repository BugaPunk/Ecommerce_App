import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/create_vendor_request.dart';
import '../../providers/admin_provider.dart';
import '../../utils/responsive_layout.dart';

class VendorFormScreen extends StatefulWidget {
  const VendorFormScreen({super.key});

  @override
  State<VendorFormScreen> createState() => _VendorFormScreenState();
}

class _VendorFormScreenState extends State<VendorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _createVendor() async {
    if (_formKey.currentState!.validate()) {
      final createVendorRequest = CreateVendorRequest(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final success = await adminProvider.createVendor(createVendorRequest);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vendedor creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(adminProvider.errorMessage ?? 'Error al crear vendedor'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Vendedor'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context, adminProvider),
        desktop: _buildDesktopLayout(context, adminProvider),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AdminProvider adminProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado
                Icon(
                  Icons.person_add,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Crear Nuevo Vendedor',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete el formulario para crear un nuevo usuario con rol de vendedor',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                
                // Formulario
                _buildFormFields(context, adminProvider),
                const SizedBox(height: 24),
                
                // Botones de acción
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: adminProvider.loading ? null : _createVendor,
                      icon: adminProvider.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(adminProvider.loading ? 'Creando...' : 'Crear Vendedor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: adminProvider.loading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AdminProvider adminProvider) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.all(32.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Panel lateral izquierdo
              Container(
                width: 320,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 80,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Crear Nuevo Vendedor',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Complete el formulario para crear un nuevo usuario con rol de vendedor en la plataforma.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Información',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Los vendedores podrán gestionar productos y ver sus ventas en la plataforma.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Añadimos un indicador de campos requeridos
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Todos los campos son obligatorios excepto Nombre y Apellido',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Formulario
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado con botón de volver
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              tooltip: 'Volver a la lista',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Información del Vendedor',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Formulario con scroll
                        Expanded(
                          child: SingleChildScrollView(
                            child: _buildFormFields(context, adminProvider),
                          ),
                        ),
                        
                        // Botones de acción
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            // Botón de cancelar
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: adminProvider.loading
                                    ? null
                                    : () {
                                        Navigator.of(context).pop();
                                      },
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancelar'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Botón de crear
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: adminProvider.loading ? null : _createVendor,
                                icon: adminProvider.loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.save),
                                label: Text(adminProvider.loading ? 'Creando...' : 'Crear Vendedor'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(BuildContext context, AdminProvider adminProvider) {
    // Determinar si estamos en modo escritorio o móvil
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    // Widget para mostrar el mensaje de error
    final errorWidget = adminProvider.errorMessage != null
        ? Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    adminProvider.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
    
    // Campos de formulario requeridos
    final requiredFields = [
      // Nombre de usuario
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Nombre de Usuario',
            prefixIcon: Icon(Icons.person),
            hintText: 'Mínimo 3 caracteres, máximo 20',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El nombre de usuario es requerido';
            }
            if (value.trim().length < 3) {
              return 'El nombre de usuario debe tener al menos 3 caracteres';
            }
            if (value.trim().length > 20) {
              return 'El nombre de usuario no puede exceder 20 caracteres';
            }
            return null;
          },
        ),
      ),
      
      // Correo electrónico
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            prefixIcon: Icon(Icons.email),
            hintText: 'Formato de email válido, máximo 50 caracteres',
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El correo electrónico es requerido';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Ingrese un correo electrónico válido';
            }
            if (value.trim().length > 50) {
              return 'El correo electrónico no puede exceder 50 caracteres';
            }
            return null;
          },
        ),
      ),
      
      // Contraseña
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock),
            hintText: 'Mínimo 6 caracteres, máximo 40',
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
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La contraseña es requerida';
            }
            if (value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            if (value.length > 40) {
              return 'La contraseña no puede exceder 40 caracteres';
            }
            return null;
          },
        ),
      ),
      
      // Confirmar contraseña
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirmar Contraseña',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La confirmación de contraseña es requerida';
            }
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
        ),
      ),
    ];
    
    // Título de información personal
    final personalInfoTitle = Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        'Información Personal (Opcional)',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
    
    // Campos de información personal
    final personalInfoFields = [
      // Nombre
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            prefixIcon: Icon(Icons.person_outline),
            hintText: 'Máximo 50 caracteres',
          ),
          validator: (value) {
            if (value != null && value.length > 50) {
              return 'El nombre no puede exceder 50 caracteres';
            }
            return null;
          },
        ),
      ),
      
      // Apellido
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            labelText: 'Apellido',
            prefixIcon: Icon(Icons.person_outline),
            hintText: 'Máximo 50 caracteres',
          ),
          validator: (value) {
            if (value != null && value.length > 50) {
              return 'El apellido no puede exceder 50 caracteres';
            }
            return null;
          },
        ),
      ),
    ];
    
    // Diseño para escritorio (dos columnas)
    if (isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campos requeridos y opcionales en dos columnas
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda - Campos requeridos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: requiredFields,
                ),
              ),
              
              const SizedBox(width: 32), // Espacio entre columnas
              
              // Columna derecha - Información personal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    personalInfoTitle,
                    ...personalInfoFields,
                  ],
                ),
              ),
            ],
          ),
          
          // Mensaje de error (si existe)
          errorWidget,
        ],
      );
    } 
    // Diseño para móvil (una columna)
    else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campos requeridos
          ...requiredFields,
          
          // Información personal
          personalInfoTitle,
          ...personalInfoFields,
          
          // Mensaje de error (si existe)
          errorWidget,
        ],
      );
    }
  }


}