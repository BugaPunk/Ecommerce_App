import 'package:flutter/material.dart';

import '../../../models/category.dart';
import '../../../utils/size_config.dart';
import 'section_title.dart';

class Categories extends StatelessWidget {
  final List<Category> categories;

  const Categories({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Categorías",
            press: () {
              // TODO: Navegar a la lista de categorías
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...categories.map((category) => CategoryCard(category: category)),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getCategoryIcon(category.nombre),
                color: const Color(0xFFFF7643),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(5)),
            Text(
              category.nombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(12),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electrónica':
        return Icons.devices;
      case 'ropa':
        return Icons.shopping_bag;
      case 'hogar':
        return Icons.home;
      case 'deportes':
        return Icons.sports;
      case 'juguetes':
        return Icons.toys;
      case 'libros':
        return Icons.book;
      case 'música':
        return Icons.music_note;
      case 'películas':
        return Icons.movie;
      case 'jardín':
        return Icons.landscape;
      case 'mascotas':
        return Icons.pets;
      default:
        return Icons.category;
    }
  }
}