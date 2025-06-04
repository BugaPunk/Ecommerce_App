import 'package:flutter/material.dart';
import '../../utils/size_config.dart';
import '../../utils/responsive_layout.dart';
import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static String routeName = "/splash";
  
  @override
  Widget build(BuildContext context) {
    // Inicializar SizeConfig para cálculos responsivos
    SizeConfig().init(context);
    
    return Scaffold(
      // Usamos el color de fondo del tema actual
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      // Usamos SafeArea para evitar problemas con notches y barras de sistema
      body: SafeArea(
        child: Body(),
      ),
    );
  }
}