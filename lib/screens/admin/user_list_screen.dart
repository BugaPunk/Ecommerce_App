import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/admin_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/admin_drawer.dart';
import 'user_detail_screen.dart';
import 'vendor_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  // Término de búsqueda
  String _searchTerm = '';
  // Filtro de rol seleccionado
  String _selectedRoleFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    // Cargar la lista de usuarios al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).getAllUsers();
    });
    
    // Añadir listener al controlador de búsqueda
    _searchController.addListener(_filterUsers);
  }
  
  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }
  
  // Método para filtrar usuarios según el término de búsqueda y rol
  void _filterUsers() {
    setState(() {
      _searchTerm = _searchController.text.toLowerCase().trim();
    });
  }
  
  // Método para obtener los usuarios filtrados
  List<User> _getFilteredUsers(List<User> users) {
    List<User> filteredUsers = users;
    
    // Filtrar por rol
    if (_selectedRoleFilter != 'Todos') {
      filteredUsers = filteredUsers.where((user) {
        return user.roles.any((role) => role.contains(_selectedRoleFilter.toUpperCase()));
      }).toList();
    }
    
    // Filtrar por término de búsqueda
    if (_searchTerm.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return user.username.toLowerCase().contains(_searchTerm) ||
               user.email.toLowerCase().contains(_searchTerm) ||
               user.firstName.toLowerCase().contains(_searchTerm) ||
               user.lastName.toLowerCase().contains(_searchTerm) ||
               user.id.toString().contains(_searchTerm);
      }).toList();
    }
    
    return filteredUsers;
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
        title: const Text('Administración de Usuarios'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).getAllUsers();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      drawer: const AdminDrawer(),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VendorFormScreen(),
            ),
          ).then((_) {
            // Recargar la lista de usuarios al volver
            Provider.of<AdminProvider>(context, listen: false).getAllUsers();
          });
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo Vendedor'),
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
                    adminProvider.getAllUsers();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (adminProvider.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay usuarios registrados',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const VendorFormScreen(),
                      ),
                    ).then((_) {
                      adminProvider.getAllUsers();
                    });
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Crear Vendedor'),
                ),
              ],
            ),
          );
        }

        // Obtener usuarios filtrados
        final filteredUsers = _getFilteredUsers(adminProvider.users);

        // Mostrar mensaje cuando no hay resultados de búsqueda
        if (filteredUsers.isEmpty && (_searchTerm.isNotEmpty || _selectedRoleFilter != 'Todos')) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron usuarios con los filtros aplicados',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _selectedRoleFilter = 'Todos';
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar filtros'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Filtros para móvil
            _buildMobileFilters(),
            
            // Lista de usuarios
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await adminProvider.getAllUsers();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _buildUserCard(context, user, adminProvider);
                  },
                ),
              ),
            ),
          ],
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
                    adminProvider.getAllUsers();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (adminProvider.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay usuarios registrados',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const VendorFormScreen(),
                      ),
                    ).then((_) {
                      adminProvider.getAllUsers();
                    });
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Crear Vendedor'),
                ),
              ],
            ),
          );
        }

        // Obtener usuarios filtrados
        final filteredUsers = _getFilteredUsers(adminProvider.users);

        return Column(
          children: [
            // Filtros para escritorio
            _buildDesktopFilters(),
            
            // Tabla de usuarios para escritorio
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await adminProvider.getAllUsers();
                },
                child: filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron usuarios con los filtros aplicados',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedRoleFilter = 'Todos';
                                });
                              },
                              icon: const Icon(Icons.clear),
                              label: const Text('Limpiar filtros'),
                            ),
                          ],
                        ),
                      )
                    : _buildUsersTable(context, filteredUsers, adminProvider),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMobileFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Campo de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, email...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchTerm.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filtro de rol
          Row(
            children: [
              const Text('Filtrar por rol: '),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedRoleFilter,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['Todos', 'Admin', 'Vendedor', 'Usuario']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoleFilter = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFilters() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          // Campo de búsqueda
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, email, ID...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchTerm.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Filtro de rol
          const Text('Filtrar por rol: '),
          const SizedBox(width: 8),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: _selectedRoleFilter,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: ['Todos', 'Admin', 'Vendedor', 'Usuario']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoleFilter = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user, AdminProvider adminProvider) {
    final mainRole = _getUserMainRole(user);
    final roleColor = _getRoleColor(mainRole);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(userId: user.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: roleColor,
                    child: Text(
                      user.username.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: user.active
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Ver detalles',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(userId: user.id),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          user.active ? Icons.block : Icons.check_circle,
                          color: user.active ? Colors.red : Colors.green,
                        ),
                        tooltip: user.active ? 'Desactivar' : 'Activar',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          _showToggleStatusDialog(context, user, adminProvider);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTable(BuildContext context, List<User> users, AdminProvider adminProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 56,
          dataRowHeight: 72,
          columns: const [
            DataColumn(
              label: Text(
                'Usuario',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Nombre Completo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Rol',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Estado',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Acciones',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: users.map((user) {
            final mainRole = _getUserMainRole(user);
            final roleColor = _getRoleColor(mainRole);

            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: roleColor,
                        child: Text(
                          user.username.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(user.username),
                    ],
                  ),
                ),
                DataCell(Text(user.email)),
                DataCell(Text('${user.firstName} ${user.lastName}')),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
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
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: user.active
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
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
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Ver detalles',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(userId: user.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          user.active ? Icons.block : Icons.check_circle,
                          color: user.active ? Colors.red : Colors.green,
                        ),
                        tooltip: user.active ? 'Desactivar' : 'Activar',
                        onPressed: () {
                          _showToggleStatusDialog(context, user, adminProvider);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
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
                ? '¿Estás seguro de que deseas desactivar al usuario "${user.username}"?'
                : '¿Estás seguro de que deseas activar al usuario "${user.username}"?',
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