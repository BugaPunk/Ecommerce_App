import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../utils/size_config.dart';
import '../../profile_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SearchField(),
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
          //Carrito
          IconBtnWithCounter(
            icon: Icons.shopping_cart_outlined,
            press: () {},
          ),
          SizedBox(width: getProportionateScreenWidth(5)),
          //Notificaciones
          IconBtnWithCounter(
            icon: Icons.notifications_none_outlined,
            numOfItems: 3,
            press: () {},
          ),
          SizedBox(width: getProportionateScreenWidth(5)),
          //Perfil
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: getProportionateScreenWidth(15),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user?.username.substring(0, 1).toUpperCase() ?? "U",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}