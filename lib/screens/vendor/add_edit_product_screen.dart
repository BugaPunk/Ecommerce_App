import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({Key? key, this.product}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productService = ProductService();
  final _categoryService = CategoryService();
  
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _stockController;
  
  int? _selectedCategoryId;
  String _selectedEstado = 'ACTIVO';
  bool _isLoading = false;
  String? _error;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.product?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.product?.descripcion ?? '');
    _precioController = TextEditingController(text: widget.product?.precio.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
    _selectedCategoryId = widget.product?.categoriaId;
    _selectedEstado = widget.product?.estado ?? 'ACTIVO';
    _loadCategories();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryService.getAllCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar categorías: $e';
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una categoría')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final product = Product(
        id: widget.product?.id ?? 0,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
        stock: int.parse(_stockController.text),
        estado: _selectedEstado,
        fechaRegistro: widget.product?.fechaRegistro ?? DateTime.now().toIso8601String(),
        categoriaId: _selectedCategoryId!,
      );

      if (widget.product == null) {
        await _productService.createProduct(product);
      } else {
        await _productService.updateProduct(product.id, product);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Agregar Producto' : 'Editar Producto'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre del producto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la descripción del producto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _precioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el precio del producto';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor ingresa un precio válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el stock del producto';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona una categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedEstado,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'ACTIVO',
                          child: Text('Activo'),
                        ),
                        DropdownMenuItem(
                          value: 'INACTIVO',
                          child: Text('Inactivo'),
                        ),
                        DropdownMenuItem(
                          value: 'AGOTADO',
                          child: Text('Agotado'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedEstado = value!;
                        });
                      },
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      child: Text(widget.product == null ? 'Agregar Producto' : 'Guardar Cambios'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 