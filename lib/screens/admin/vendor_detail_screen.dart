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
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@${vendor.username}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.grey.shade300 
                                    : Colors.grey.shade700,
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
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
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
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
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
                              Text(
                                'No hay productos registrados',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Los productos se mostrarán aquí cuando estén disponibles',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? Colors.grey.shade400 
                                      : Colors.grey.shade600,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.grey.shade700;
    final cardColor = isDarkMode 
        ? Theme.of(context).colorScheme.surfaceVariant 
        : Theme.of(context).colorScheme.surface;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    
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
                Text(
                  'No se encontró información del vendedor',
                  style: TextStyle(fontSize: 20, color: textColor),
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

        // Calcular el ancho del panel izquierdo basado en el ancho de la pantalla
        final screenWidth = MediaQuery.of(context).size.width;
        final leftPanelWidth = screenWidth < 1200 
            ? screenWidth * 0.3 // 30% en pantallas medianas
            : screenWidth * 0.25; // 25% en pantallas grandes

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con botón de volver
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, 
                        color: Theme.of(context).colorScheme.onPrimaryContainer),
                      tooltip: 'Volver a la lista',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Detalles del Vendedor',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Contenido principal
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Panel izquierdo - Información básica
                    SizedBox(
                      width: leftPanelWidth,
                      child: Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: SingleChildScrollView(
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
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '@${vendor.username}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: subtitleColor,
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
                                Divider(color: borderColor),
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
                                
                                const SizedBox(height: 24),
                                Divider(color: borderColor),
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
                                const SizedBox(height: 8), // Espacio adicional al final
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    
                    // Panel derecho - Información detallada y estadísticas
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tarjeta de información detallada
                            Card(
                              color: cardColor,
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
                                          Icons.assignment,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Ficha Completa',
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: textColor,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.refresh, 
                                            color: Theme.of(context).colorScheme.primary),
                                          tooltip: 'Actualizar información',
                                          onPressed: () {
                                            adminProvider.getVendorDetails(widget.vendorId);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Información en formato de tabla
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: borderColor),
                                        borderRadius: BorderRadius.circular(8),
                                        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columns: [
                                            DataColumn(label: Text('Campo', style: TextStyle(color: textColor))),
                                            DataColumn(label: Text('Valor', style: TextStyle(color: textColor))),
                                          ],
                                          rows: [
                                            _buildDataRow('ID', vendor.id.toString(), textColor),
                                            _buildDataRow('Nombre de Usuario', vendor.username, textColor),
                                            _buildDataRow('Correo Electrónico', vendor.email, textColor),
                                            _buildDataRow('Nombre', vendor.firstName.isEmpty ? 'No especificado' : vendor.firstName, textColor),
                                            _buildDataRow('Apellido', vendor.lastName.isEmpty ? 'No especificado' : vendor.lastName, textColor),
                                            _buildDataRow('Roles', vendor.roles.join(', '), textColor),
                                            _buildDataRow('Estado', vendor.active ? 'Activo' : 'Inactivo', textColor),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Tarjeta de estadísticas (placeholder)
                            Card(
                              color: cardColor,
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
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Estadísticas en tarjetas - Ahora en un grid para mejor uso del espacio
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        // Determinar cuántas tarjetas por fila según el ancho disponible
                                        final cardWidth = 200.0; // Ancho deseado para cada tarjeta
                                        final spacing = 16.0;
                                        final availableWidth = constraints.maxWidth;
                                        final cardsPerRow = (availableWidth / (cardWidth + spacing)).floor();
                                        
                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: spacing,
                                          children: [
                                            _buildStatCard(
                                              context,
                                              'Total Productos',
                                              '0',
                                              Icons.inventory,
                                              Colors.blue,
                                              isDarkMode,
                                            ),
                                            _buildStatCard(
                                              context,
                                              'Ventas Totales',
                                              '0',
                                              Icons.attach_money,
                                              Colors.green,
                                              isDarkMode,
                                            ),
                                            _buildStatCard(
                                              context,
                                              'Valoración',
                                              'N/A',
                                              Icons.star,
                                              Colors.amber,
                                              isDarkMode,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 32),
                                    
                                    // Mensaje de placeholder
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.inventory_2_outlined,
                                            size: 64,
                                            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No hay productos registrados',
                                            style: TextStyle(fontSize: 18, color: textColor),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Los productos y estadísticas se mostrarán aquí cuando estén disponibles',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: subtitleColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16), // Espacio adicional al final
                          ],
                        ),
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
  
  DataRow _buildDataRow(String label, String value, [Color? textColor]) {
    return DataRow(
      cells: [
        DataCell(Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )),
        DataCell(Text(
          value,
          style: TextStyle(color: textColor),
        )),
      ],
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    [bool isDarkMode = false]
  ) {
    // Ajustar el color de fondo para que sea más visible en modo oscuro
    final bgColor = isDarkMode 
        ? color.withOpacity(0.2) 
        : color.withOpacity(0.1);
    
    // Ajustar el color del texto para que sea más visible en modo oscuro
    final titleColor = isDarkMode 
        ? Colors.white70 
        : Colors.grey.shade700;
    
    return Container(
      width: 200, // Ancho fijo para mejor distribución
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: isDarkMode ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
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
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final valueColor = isDarkMode ? Colors.white : Colors.black87;
    
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
                        color: labelColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}