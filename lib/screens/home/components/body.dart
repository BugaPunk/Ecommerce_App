import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/category_service.dart';
import '../../../services/product_service.dart';
import '../../../utils/size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_products.dart';
import 'special_offers.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final productsResponse = await _productService.getProducts();
      final categoriesResponse = await _categoryService.getCategories();
      
      setState(() {
        _products = productsResponse;
        _categories = categoriesResponse;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(20)),
            const HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(20)),
            const DiscountBanner(),
            SizedBox(height: getProportionateScreenWidth(20)),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Column(
                children: [
                  Categories(categories: _categories),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  SpecialOffers(products: _products.where((p) => p.isPopular).toList()),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  PopularProducts(products: _products),
                  SizedBox(height: getProportionateScreenWidth(20)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}