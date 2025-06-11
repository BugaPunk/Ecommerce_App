import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../models/category.dart' as cat;
import '../../providers/product_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/vendor_drawer.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({
    super.key,
    this.product,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  
  String _selectedEstado = 'ACTIVO';
  int? _selectedCategoriaId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Si estamos editando, llenar los campos con los datos del producto
    if (widget.product != null) {
      _nombreController.text = widget.product!.nombre;
      _descripcionController.text = widget.product!.descripcion;
      _precioController.text = widget.product!.precio.toString();
      _stockController.text = widget.product!.stock.toString();
      _selectedEstado = widget.product!.estado;
      _selectedCategoriaId = widget.product!.categoriaId;
    }

    // Cargar categorías
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.product != null;

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      
      final product = Product(
        id: _isEditing ? widget.product!.id : 0,
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        precio: double.parse(_precioController.text),
        stock: int.parse(_stockController.text),
        estado: _selectedEstado,
        fechaRegistro: _isEditing ? widget.product!.fechaRegistro : DateTime.now().toIso8601String(),
        categoriaId: _selectedCategoriaId!,
      );

      bool success;
      if (_isEditing) {
        success = await productProvider.updateProduct(widget.product!.id, product);
      } else {
        success = await productProvider.createProduct(product);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing 
                  ? 'Producto actualizado correctamente'
                  : 'Producto creado correctamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              productProvider.errorMessage ?? 
              (_isEditing 
                  ? 'Error al actualizar el producto'
                  : 'Error al crear el producto'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Nuevo Producto'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveProduct,
              child: Text(
                _isEditing ? 'Actualizar' : 'Guardar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      drawer: const VendorDrawer(),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto (placeholder)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 48,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agregar imagen\n(Próximamente)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Formulario
            _buildFormFields(),
            
            const SizedBox(height: 32),
            
            // Botón de guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Actualizar Producto' : 'Crear Producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 64,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Agregar imagen\n(Próximamente)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 32),
                
                // Formulario
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildFormFields(),
                      
                      const SizedBox(height: 32),
                      
                      // Botón de guardar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProduct,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(_isEditing ? 'Actualizar Producto' : 'Crear Producto'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del producto
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto *',
                hintText: 'Ingresa el nombre del producto',
                prefixIcon: Icon(Icons.inventory_2),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                if (value.trim().length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            
            const SizedBox(height: 16),
            
            // Descripción
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción *',
                hintText: 'Describe el producto',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                if (value.trim().length < 10) {
                  return 'La descripción debe tener al menos 10 caracteres';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 16),
            
            // Precio y Stock en fila
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      labelText: 'Precio *',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.attach_money),
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El precio es obligatorio';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'Ingresa un precio válido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock *',
                      hintText: '0',
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El stock es obligatorio';
                      }
                      final stock = int.tryParse(value);
                      if (stock == null || stock < 0) {
                        return 'Ingresa un stock válido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Estado y Categoría en fila
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedEstado,
                    decoration: const InputDecoration(
                      labelText: 'Estado *',
                      prefixIcon: Icon(Icons.toggle_on),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ACTIVO', child: Text('Activo')),
                      DropdownMenuItem(value: 'INACTIVO', child: Text('Inactivo')),
                      DropdownMenuItem(value: 'AGOTADO', child: Text('Agotado')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedEstado = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona un estado';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedCategoriaId,
                    decoration: const InputDecoration(
                      labelText: 'Categoría *',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: productProvider.categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoriaId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecciona una categoría';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Información adicional
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Información adicional',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• El nombre debe ser descriptivo y único\n'
                      '• La descripción ayuda a los clientes a entender el producto\n'
                      '• El precio debe incluir impuestos si aplica\n'
                      '• El stock se actualizará automáticamente con las ventas',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}