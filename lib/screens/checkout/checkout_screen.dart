import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/payment_info.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../components/default_button.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      
      // Verificar que el carrito no esté vacío
      if (cartProvider.items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El carrito está vacío'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Crear información de pago
      final paymentInfo = PaymentInfo(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cardHolderName: _cardHolderController.text,
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
      );

      // Paso 1: Crear orden a partir del carrito
      // La API procesa el pedido a partir del carrito del usuario autenticado
      final order = await orderProvider.createOrder(
        cartProvider.items,
        cartProvider.totalAmount,
      );

      if (order != null) {
        // Paso 2: Procesar pago con la información de la tarjeta
        // La API espera: pedidoId, metodoPago, numeroTarjeta, fechaExpiracion, cvv
        final success = await orderProvider.processPayment(order, paymentInfo);
        
        if (success && mounted) {
          // Paso 3: Limpiar carrito después de un pago exitoso
          await cartProvider.clearCart();
          
          // Paso 4: Navegar a pantalla de éxito
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(order: order),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(orderProvider.error ?? 'Error al procesar el pago'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderProvider.error ?? 'Error al crear la orden'),
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
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.totalAmount;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: cartProvider.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega productos para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Explorar productos'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Resumen de compra'),
                    const SizedBox(height: 8),
                    _buildOrderSummary(context, cartProvider),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Información de pago'),
                    const SizedBox(height: 16),
                    _buildCardNumberField(),
                    const SizedBox(height: 16),
                    _buildCardHolderField(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildExpiryDateField(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCVVField(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 32),
                    _buildTotalAmount(context, total),
                    const SizedBox(height: 16),
                    _buildPayButton(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cartProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${cartProvider.itemCount} productos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            ...cartProvider.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.name}',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      decoration: const InputDecoration(
        labelText: 'Número de tarjeta',
        hintText: '1234 5678 9012 3456',
        prefixIcon: Icon(Icons.credit_card),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CardNumberFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa el número de tarjeta';
        }
        if (value.replaceAll(' ', '').length < 16) {
          return 'El número de tarjeta debe tener 16 dígitos';
        }
        return null;
      },
    );
  }

  Widget _buildCardHolderField() {
    return TextFormField(
      controller: _cardHolderController,
      decoration: const InputDecoration(
        labelText: 'Nombre del titular',
        hintText: 'NOMBRE APELLIDO',
        prefixIcon: Icon(Icons.person),
      ),
      textCapitalization: TextCapitalization.characters,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa el nombre del titular';
        }
        return null;
      },
    );
  }

  Widget _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryDateController,
      decoration: const InputDecoration(
        labelText: 'Fecha de expiración',
        hintText: 'MM/YY',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _ExpiryDateFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa la fecha';
        }
        if (value.length < 5) {
          return 'Formato inválido';
        }
        
        // Validar que la fecha no esté expirada
        final parts = value.split('/');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final year = int.tryParse('20${parts[1]}');
          
          if (month != null && year != null) {
            final now = DateTime.now();
            final expiryDate = DateTime(year, month + 1, 0);
            
            if (expiryDate.isBefore(now)) {
              return 'Tarjeta expirada';
            }
          }
        }
        
        return null;
      },
    );
  }

  Widget _buildCVVField() {
    return TextFormField(
      controller: _cvvController,
      decoration: const InputDecoration(
        labelText: 'CVV',
        hintText: '123',
        prefixIcon: Icon(Icons.security),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa el CVV';
        }
        if (value.length < 3) {
          return 'CVV inválido';
        }
        return null;
      },
    );
  }



  Widget _buildTotalAmount(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total a pagar:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: kPrimaryColor.withOpacity(0.6),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Pagar ahora',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

// Formatter para el número de tarjeta (agrega espacios cada 4 dígitos)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String formatted = PaymentInfo.formatCardNumber(newValue.text);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formatter para la fecha de expiración (formato MM/YY)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String text = newValue.text;
    final StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i == 2 && text.length > 2 && !text.contains('/')) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }
    
    final String formatted = buffer.toString();
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}