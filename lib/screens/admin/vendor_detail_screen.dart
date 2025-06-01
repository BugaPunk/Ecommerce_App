import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';
import '../../utils/responsive_layout.dart';

class VendorDetailScreen extends StatefulWidget {
  final int vendorId;

  const VendorDetailScreen({
    super.key,
    required this.vendorId,
  });

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar los detalles del vendedor al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false)
          .getVendorDetails(widget.vendorId);
    });
  }

  @override
  void dispose() {
    // Limpiar el vendedor seleccionado al salir de la pantalla
    Provider.of<AdminProvider>(context, listen: false).clearSelectedVendor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Vendedor'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                    adminProvider.getVendorDetails(widget.vendorId);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final vendor = adminProvider.selectedVendor;
        if (vendor == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No se encontró información del vendedor',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver a la lista'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await adminProvider.getVendorDetails(widget.vendorId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta de perfil
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                vendor.username.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 48,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: vendor.active ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                vendor.active ? 'Activo' : 'Inactivo',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '${vendor.firstName} ${vendor.lastName}',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@${vendor.username}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Chip(
                          label: Text(vendor.roles.join(', ')),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        // Botón de activar/desactivar
                        ElevatedButton.icon(
                          onPressed: () async {
                            final success = await adminProvider.toggleVendorStatus(
                              vendor.id,
                              !vendor.active,
                            );
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    vendor.active
                                        ? 'Vendedor desactivado correctamente'
                                        : 'Vendedor activado correctamente',
                                  ),
                                  backgroundColor:
                                      vendor.active ? Colors.orange : Colors.green,
                                ),
                              );
                            }
                          },
                          icon: Icon(vendor.active ? Icons.block : Icons.check_circle),
                          label: Text(vendor.active ? 'Desactivar Vendedor' : 'Activar Vendedor'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vendor.active ? Colors.orange : Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Tarjeta de información
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información del Vendedor',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildInfoItem(
                          context,
                          'ID',
                          vendor.id.toString(),
                          Icons.tag,
                        ),
                        const Divider(),
                        _buildInfoItem(
                          context,
                          'Nombre de Usuario',
                          vendor.username,
                          Icons.person,
                        ),
                        const Divider(),
                        _buildInfoItem(
                          context,
                          'Correo Electrónico',
                          vendor.email,
                          Icons.email,
                        ),
                        const Divider(),
                        _buildInfoItem(
                          context,
                          'Nombre',
                          vendor.firstName.isEmpty ? 'No especificado' : vendor.firstName,
                          Icons.badge,
                        ),
                        const Divider(),
                        _buildInfoItem(
                          context,
                          'Apellido',
                          vendor.lastName.isEmpty ? 'No especificado' : vendor.lastName,
                          Icons.badge_outlined,
                        ),
                        const Divider(),
                        _buildInfoItem(
                          context,
                          'Roles',
                          vendor.roles.join(', '),
                          Icons.security,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Espacio para futuras secciones
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Productos del Vendedor',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No hay productos registrados',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Los productos se mostrarán aquí cuando estén disponibles',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
                    adminProvider.getVendorDetails(widget.vendorId);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final vendor = adminProvider.selectedVendor;
        if (vendor == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 24),
                const Text(
                  'No se encontró información del vendedor',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver a la lista'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con botón de actualizar
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
                    'Detalles del Vendedor',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Actualizar información',
                    onPressed: () {
                      adminProvider.getVendorDetails(widget.vendorId);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Contenido principal
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Panel izquierdo - Información básica
                    SizedBox(
                      width: 320,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      vendor.username.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 64,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: vendor.active ? Colors.green : Colors.red,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Text(
                                      vendor.active ? 'Activo' : 'Inactivo',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Text(
                                '${vendor.firstName} ${vendor.lastName}',
                                style: Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '@${vendor.username}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              Chip(
                                label: Text(vendor.roles.join(', ')),
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              ),
                              const SizedBox(height: 32),
                              const Divider(),
                              const SizedBox(height: 24),
                              
                              // Información básica
                              _buildInfoItem(
                                context,
                                'ID',
                                vendor.id.toString(),
                                Icons.tag,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoItem(
                                context,
                                'Correo Electrónico',
                                vendor.email,
                                Icons.email,
                              ),
                              
                              const Spacer(),
                              const Divider(),
                              const SizedBox(height: 24),
                              
                              // Botón de activar/desactivar
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final success = await adminProvider.toggleVendorStatus(
                                    vendor.id,
                                    !vendor.active,
                                  );
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          vendor.active
                                              ? 'Vendedor desactivado correctamente'
                                              : 'Vendedor activado correctamente',
                                        ),
                                        backgroundColor:
                                            vendor.active ? Colors.orange : Colors.green,
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(vendor.active ? Icons.block : Icons.check_circle),
                                label: Text(vendor.active ? 'Desactivar Vendedor' : 'Activar Vendedor'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: vendor.active ? Colors.orange : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    
                    // Panel derecho - Información detallada y estadísticas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tarjeta de información detallada
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Información Detallada',
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Información en formato de tabla
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Campo')),
                                        DataColumn(label: Text('Valor')),
                                      ],
                                      rows: [
                                        _buildDataRow('ID', vendor.id.toString()),
                                        _buildDataRow('Nombre de Usuario', vendor.username),
                                        _buildDataRow('Correo Electrónico', vendor.email),
                                        _buildDataRow('Nombre', vendor.firstName.isEmpty ? 'No especificado' : vendor.firstName),
                                        _buildDataRow('Apellido', vendor.lastName.isEmpty ? 'No especificado' : vendor.lastName),
                                        _buildDataRow('Roles', vendor.roles.join(', ')),
                                        _buildDataRow('Estado', vendor.active ? 'Activo' : 'Inactivo'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Tarjeta de estadísticas (placeholder)
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_bag,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Productos y Estadísticas',
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Estadísticas en tarjetas
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            context,
                                            'Total Productos',
                                            '0',
                                            Icons.inventory,
                                            Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildStatCard(
                                            context,
                                            'Ventas Totales',
                                            '0',
                                            Icons.attach_money,
                                            Colors.green,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildStatCard(
                                            context,
                                            'Valoración',
                                            'N/A',
                                            Icons.star,
                                            Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    
                                    // Mensaje de placeholder
                                    Expanded(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.inventory_2_outlined,
                                              size: 64,
                                              color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'No hay productos registrados',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Los productos y estadísticas se mostrarán aquí cuando estén disponibles',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  DataRow _buildDataRow(String label, String value) {
    return DataRow(
      cells: [
        DataCell(Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(value)),
      ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}