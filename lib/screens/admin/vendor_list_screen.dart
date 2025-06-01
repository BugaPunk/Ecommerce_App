import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/admin_provider.dart';
import '../../utils/responsive_layout.dart';
import 'vendor_detail_screen.dart';
import 'vendor_form_screen.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  // Término de búsqueda
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    // Cargar la lista de vendedores al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).getVendors();
    });
    
    // Añadir listener al controlador de búsqueda
    _searchController.addListener(_filterVendors);
  }
  
  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _searchController.removeListener(_filterVendors);
    _searchController.dispose();
    super.dispose();
  }
  
  // Método para filtrar vendedores según el término de búsqueda
  void _filterVendors() {
    setState(() {
      _searchTerm = _searchController.text.toLowerCase().trim();
    });
  }
  
  // Método para obtener los vendedores filtrados
  List<User> _getFilteredVendors(List<User> vendors) {
    if (_searchTerm.isEmpty) {
      return vendors; // Devolver todos los vendedores si no hay término de búsqueda
    }
    
    // Filtrar vendedores que coincidan con el término de búsqueda
    return vendors.where((vendor) {
      return vendor.username.toLowerCase().contains(_searchTerm) ||
             vendor.email.toLowerCase().contains(_searchTerm) ||
             vendor.firstName.toLowerCase().contains(_searchTerm) ||
             vendor.lastName.toLowerCase().contains(_searchTerm) ||
             vendor.id.toString().contains(_searchTerm);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Vendedores'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
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
            // Recargar la lista de vendedores al volver
            Provider.of<AdminProvider>(context, listen: false).getVendors();
          });
        },
        icon: const Icon(Icons.add),
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
                    adminProvider.getVendors();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (adminProvider.vendors.isEmpty) {
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
                  'No hay vendedores registrados',
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
                      adminProvider.getVendors();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Vendedor'),
                ),
              ],
            ),
          );
        }

        // Obtener vendedores filtrados
        final filteredVendors = _getFilteredVendors(adminProvider.vendors);

        // Mostrar mensaje cuando no hay resultados de búsqueda
        if (filteredVendors.isEmpty && _searchTerm.isNotEmpty) {
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
                  'No se encontraron vendedores que coincidan con "$_searchTerm"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar búsqueda'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Campo de búsqueda para móvil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
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
            ),
            
            // Lista de vendedores
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await adminProvider.getVendors();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredVendors.length,
                  itemBuilder: (context, index) {
                    final vendor = filteredVendors[index];
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
                              builder: (context) => VendorDetailScreen(vendorId: vendor.id),
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
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      vendor.username.substring(0, 1).toUpperCase(),
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
                                          vendor.username,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          vendor.email,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: vendor.active
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      vendor.active ? 'Activo' : 'Inactivo',
                                      style: TextStyle(
                                        color: vendor.active ? Colors.green : Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                    '${vendor.firstName} ${vendor.lastName}',
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
                                              builder: (context) => VendorDetailScreen(vendorId: vendor.id),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Switch(
                                        value: vendor.active,
                                        onChanged: (value) async {
                                          final success = await adminProvider.toggleVendorStatus(
                                            vendor.id,
                                            value,
                                          );
                                          if (success && context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  value
                                                      ? 'Vendedor activado correctamente'
                                                      : 'Vendedor desactivado correctamente',
                                                ),
                                                backgroundColor: value ? Colors.green : Colors.orange,
                                              ),
                                            );
                                          }
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
                Text(
                  'Error: ${adminProvider.errorMessage}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    adminProvider.getVendors();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (adminProvider.vendors.isEmpty) {
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
                  'No hay vendedores registrados',
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
                      adminProvider.getVendors();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Vendedor'),
                ),
              ],
            ),
          );
        }

        // Obtener vendedores filtrados
        final filteredVendors = _getFilteredVendors(adminProvider.vendors);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y botón de actualizar
              Row(
                children: [
                  Text(
                    'Gestión de Vendedores',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Actualizar lista',
                    onPressed: () {
                      adminProvider.getVendors();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tarjeta de estadísticas
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total de Vendedores',
                          _searchTerm.isEmpty 
                            ? adminProvider.vendors.length.toString()
                            : '${filteredVendors.length} / ${adminProvider.vendors.length}',
                          Icons.people,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Vendedores Activos',
                          _searchTerm.isEmpty
                            ? adminProvider.vendors.where((v) => v.active).length.toString()
                            : filteredVendors.where((v) => v.active).length.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Vendedores Inactivos',
                          _searchTerm.isEmpty
                            ? adminProvider.vendors.where((v) => !v.active).length.toString()
                            : filteredVendors.where((v) => !v.active).length.toString(),
                          Icons.cancel,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tabla de vendedores
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Vendedores Registrados',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Spacer(),
                            // Campo de búsqueda
                            SizedBox(
                              width: 300,
                              child: TextField(
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
                                onChanged: (value) {
                                  // Esto activará el listener que ya tenemos configurado
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: filteredVendors.isEmpty && _searchTerm.isNotEmpty
                            // Mostrar mensaje cuando no hay resultados de búsqueda
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
                                      'No se encontraron vendedores que coincidan con "$_searchTerm"',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                      icon: const Icon(Icons.clear),
                                      label: const Text('Limpiar búsqueda'),
                                    ),
                                  ],
                                ),
                              )
                            // Mostrar tabla con resultados
                            : SingleChildScrollView(
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Usuario')),
                                    DataColumn(label: Text('Email')),
                                    DataColumn(label: Text('Nombre')),
                                    DataColumn(label: Text('Apellido')),
                                    DataColumn(label: Text('Estado')),
                                    DataColumn(label: Text('Acciones')),
                                  ],
                                  rows: filteredVendors.map((vendor) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(vendor.id.toString())),
                                        DataCell(
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 14,
                                                backgroundColor: Theme.of(context).colorScheme.primary,
                                                child: Text(
                                                  vendor.username.substring(0, 1).toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(vendor.username),
                                            ],
                                          ),
                                        ),
                                        DataCell(Text(vendor.email)),
                                        DataCell(Text(vendor.firstName.isEmpty ? '-' : vendor.firstName)),
                                        DataCell(Text(vendor.lastName.isEmpty ? '-' : vendor.lastName)),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: vendor.active
                                                  ? Colors.green.withOpacity(0.2)
                                                  : Colors.red.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              vendor.active ? 'Activo' : 'Inactivo',
                                              style: TextStyle(
                                                color: vendor.active ? Colors.green : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.visibility),
                                                tooltip: 'Ver detalles',
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => VendorDetailScreen(vendorId: vendor.id),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Switch(
                                                value: vendor.active,
                                                onChanged: (value) async {
                                                  final success = await adminProvider.toggleVendorStatus(
                                                    vendor.id,
                                                    value,
                                                  );
                                                  if (success && context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          value
                                                              ? 'Vendedor activado correctamente'
                                                              : 'Vendedor desactivado correctamente',
                                                        ),
                                                        backgroundColor: value ? Colors.green : Colors.orange,
                                                      ),
                                                    );
                                                  }
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
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}