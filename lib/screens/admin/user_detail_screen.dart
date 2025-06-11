import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/admin_provider.dart';
import '../../utils/responsive_layout.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar los detalles del usuario al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).getUserDetails(widget.userId);
    });
  }

  @override
  void dispose() {
    // Limpiar el usuario seleccionado al salir
    Provider.of<AdminProvider>(context, listen: false).clearSelectedUser();
    super.dispose();
  }

  // Obtener el rol principal del usuario para mostrar
  String _getUserMainRole(User user) {
    if (user.roles.contains('ROLE_ADMIN')) {
      return 'Administrador';
    } else if (user.roles.contains('ROLE_VENDEDOR')) {
      return 'Vendedor';
    } else if (user.roles.contains('ROLE_USUARIO')) {
      return 'Usuario';
    }
    return 'Sin rol';
  }

  // Obtener color según el rol
  Color _getRoleColor(String role) {
    switch (role) {
      case 'Administrador':
        return Colors.purple;
      case 'Vendedor':
        return Colors.blue;
      case 'Usuario':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Consumer<AdminProvider>(
            builder: (context, adminProvider, child) {
              if (adminProvider.selectedUser != null) {
                final user = adminProvider.selectedUser!;
                return IconButton(
                  icon: Icon(
                    user.active ? Icons.block : Icons.check_circle,
                    color: user.active ? Colors.red : Colors.green,
                  ),
                  tooltip: user.active ? 'Desactivar Usuario' : 'Activar Usuario',
                  onPressed: () {
                    _showToggleStatusDialog(context, user, adminProvider);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (adminProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Error: ${adminProvider.errorMessage}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    adminProvider.getUserDetails(widget.userId);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (adminProvider.selectedUser == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = adminProvider.selectedUser!;
        final mainRole = _getUserMainRole(user);
        final roleColor = _getRoleColor(mainRole);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta principal del usuario
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar y información básica
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: roleColor,
                            child: Text(
                              user.username.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: user.active
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        user.active ? 'Activo' : 'Inactivo',
                                        style: TextStyle(
                                          color: user.active ? Colors.green : Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: roleColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        mainRole,
                                        style: TextStyle(
                                          color: roleColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Información detallada
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información Personal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('ID', user.id.toString()),
                      _buildInfoRow('Nombre de Usuario', user.username),
                      _buildInfoRow('Email', user.email),
                      _buildInfoRow('Nombre', user.firstName),
                      _buildInfoRow('Apellido', user.lastName),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Roles y permisos
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Roles y Permisos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user.roles.map((role) {
                          final displayRole = role.replaceAll('ROLE_', '');
                          final color = _getRoleColor(_getUserMainRole(user));
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              border: Border.all(color: color.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              displayRole,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botones de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showToggleStatusDialog(context, user, adminProvider);
                  },
                  icon: Icon(
                    user.active ? Icons.block : Icons.check_circle,
                  ),
                  label: Text(
                    user.active ? 'Desactivar Usuario' : 'Activar Usuario',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: user.active ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (adminProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Error: ${adminProvider.errorMessage}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    adminProvider.getUserDetails(widget.userId);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (adminProvider.selectedUser == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = adminProvider.selectedUser!;
        final mainRole = _getUserMainRole(user);
        final roleColor = _getRoleColor(mainRole);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarjeta principal del usuario
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: roleColor,
                            child: Text(
                              user.username.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: user.active
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        user.active ? 'Activo' : 'Inactivo',
                                        style: TextStyle(
                                          color: user.active ? Colors.green : Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: roleColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        mainRole,
                                        style: TextStyle(
                                          color: roleColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información detallada
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Información Personal',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow('ID', user.id.toString()),
                                _buildInfoRow('Nombre de Usuario', user.username),
                                _buildInfoRow('Email', user.email),
                                _buildInfoRow('Nombre', user.firstName),
                                _buildInfoRow('Apellido', user.lastName),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Roles y acciones
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            // Roles y permisos
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Roles y Permisos',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...user.roles.map((role) {
                                      final displayRole = role.replaceAll('ROLE_', '');
                                      final color = _getRoleColor(_getUserMainRole(user));
                                      return Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          border: Border.all(color: color.withOpacity(0.3)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          displayRole,
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Botón de acción
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showToggleStatusDialog(context, user, adminProvider);
                                },
                                icon: Icon(
                                  user.active ? Icons.block : Icons.check_circle,
                                ),
                                label: Text(
                                  user.active ? 'Desactivar' : 'Activar',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: user.active ? Colors.red : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToggleStatusDialog(BuildContext context, User user, AdminProvider adminProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(user.active ? 'Desactivar Usuario' : 'Activar Usuario'),
          content: Text(
            user.active
                ? '¿Estás seguro de que deseas desactivar al usuario "${user.username}"?\n\nEsto impedirá que el usuario pueda acceder al sistema.'
                : '¿Estás seguro de que deseas activar al usuario "${user.username}"?\n\nEsto permitirá que el usuario pueda acceder al sistema.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                final success = await adminProvider.toggleUserStatus(user.id, !user.active);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Usuario ${user.active ? 'desactivado' : 'activado'} correctamente'
                            : 'Error al cambiar el estado del usuario',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                  
                  // Recargar los detalles del usuario
                  if (success) {
                    adminProvider.getUserDetails(widget.userId);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: user.active ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(user.active ? 'Desactivar' : 'Activar'),
            ),
          ],
        );
      },
    );
  }
}