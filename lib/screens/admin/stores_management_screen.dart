import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../models/store.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/admin_drawer.dart';
import 'store_form_screen.dart';

class StoresManagementScreen extends StatefulWidget {
  const StoresManagementScreen({Key? key}) : super(key: key);

  @override
  State<StoresManagementScreen> createState() => _StoresManagementScreenState();
}

class _StoresManagementScreenState extends State<StoresManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreProvider>(context, listen: false).loadStores();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tiendas'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<StoreProvider>(context, listen: false).refresh();
            },
          ),
        ],
      ),
      drawer: const AdminDrawer(),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          if (storeProvider.loading && storeProvider.stores.isEmpty) {
            return const LoadingWidget(message: 'Cargando tiendas...');
          }

          if (storeProvider.error != null && storeProvider.stores.isEmpty) {
            return CustomErrorWidget(
              message: storeProvider.error!,
              onRetry: () => storeProvider.loadStores(),
            );
          }

          return Column(
            children: [
              // Header con estadísticas
              _buildStatsHeader(storeProvider),
              
              // Barra de búsqueda
              _buildSearchBar(storeProvider),
              
              // Lista de tiendas
              Expanded(
                child: _buildStoresList(storeProvider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToStoreForm(context),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva Tienda',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatsHeader(StoreProvider storeProvider) {
    final stats = storeProvider.getStatistics();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Tiendas',
              stats['total'].toString(),
              Icons.store,
              Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Calificación Promedio',
              stats['averageRating'].toStringAsFixed(1),
              Icons.star,
              Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(StoreProvider storeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar tiendas...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: storeProvider.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    storeProvider.clearSearch();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) {
          storeProvider.setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildStoresList(StoreProvider storeProvider) {
    final stores = storeProvider.filteredStores;

    if (stores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              storeProvider.searchQuery.isNotEmpty ? Icons.search_off : Icons.store_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              storeProvider.searchQuery.isNotEmpty
                  ? 'No se encontraron tiendas'
                  : 'No hay tiendas registradas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            if (storeProvider.searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Agrega la primera tienda',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => storeProvider.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return _buildStoreCard(store, storeProvider);
        },
      ),
    );
  }

  Widget _buildStoreCard(Store store, StoreProvider storeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showStoreDetails(context, store),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (store.codigoTienda != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              store.codigoTienda!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _navigateToStoreForm(context, store: store);
                          break;
                        case 'delete':
                          _confirmDelete(context, store, storeProvider);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                store.descripcion,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (store.email != null) ...[
                    Icon(Icons.email, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        store.email!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  if (store.calificacionPromedio != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                    const SizedBox(width: 4),
                    Text(
                      store.calificacionPromedio!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStoreForm(BuildContext context, {Store? store}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoreFormScreen(store: store),
      ),
    );
  }

  void _showStoreDetails(BuildContext context, Store store) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(store.nombre),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (store.codigoTienda != null) ...[
                _buildDetailRow('Código', store.codigoTienda!),
                const SizedBox(height: 8),
              ],
              _buildDetailRow('Descripción', store.descripcion),
              if (store.direccion != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Dirección', store.direccion!),
              ],
              if (store.telefono != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Teléfono', store.telefono!),
              ],
              if (store.email != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Email', store.email!),
              ],
              if (store.calificacionPromedio != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Calificación', '${store.calificacionPromedio!.toStringAsFixed(1)} ⭐'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToStoreForm(context, store: store);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, Store store, StoreProvider storeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar la tienda "${store.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final success = await storeProvider.deleteStore(store.id);
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tienda eliminada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(storeProvider.error ?? 'Error al eliminar tienda'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}