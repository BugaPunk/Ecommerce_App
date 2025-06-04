import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../login_screen.dart';
import 'splash_content.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  //Esta lista es para las imagenes para el deslizador
  List<Map<String, String>> splashData = [
    {
      "text": "Bienvenido a EcoShopping, Empieza a comprar!",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "Te ayudamos a conectarte con la tienda \nalredor de todo el mundo",
      "image": "assets/images/freepik__upload__2400.png"
    },
    {
      "text": "Comprar es demasiado facil \nquedate en casa con nosotros",
      "image": "assets/images/splash_3.png"
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en modo desktop o móvil
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    
    return SafeArea(
      child: isDesktop 
          ? _buildDesktopLayout(context) 
          : _buildMobileLayout(context),
    );
  }
  
  Widget _buildMobileLayout(BuildContext context) {
    // Controlador para el PageView
    final PageController pageController = PageController(initialPage: currentPage);
    
    // Determinar si estamos en modo oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Obtener el tamaño de la pantalla para ajustes responsivos
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Ajustar proporciones según el tamaño de la pantalla
    final bool isLargePhone = screenHeight > 800;
    final bool isSmallPhone = screenHeight < 600;
    
    // Ajustar flexes según el tamaño de la pantalla
    final int topFlex = isLargePhone ? 3 : isSmallPhone ? 2 : 3;
    final int bottomFlex = isLargePhone ? 2 : isSmallPhone ? 1 : 2;
    
    // Ajustar tamaño del botón según el ancho de la pantalla
    final double buttonWidth = screenWidth * 0.7 > 300 ? 300 : screenWidth * 0.7;
    
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: topFlex,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: pageController,
                  onPageChanged: (value){
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  //Deslizador de splash
                  itemBuilder: (context, index){
                    //itembuilder crea la instancia
                    final item = splashData[index]; //definimos lista
                    return SplashContent(
                      //mandamos los parametros a slashcontent
                        text: item['text']!,
                        image: item['image']!,
                    );
                  },
                ),
                
                // Flechas de navegación
                Positioned(
                  left: 5,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: isDarkMode 
                          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                          : Colors.black54,
                      size: 24,
                    ),
                    onPressed: currentPage > 0 
                        ? () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        (isDarkMode ? Colors.white10 : Colors.black12).withOpacity(0.1)
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(8)
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  right: 5,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isDarkMode 
                          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                          : Colors.black54,
                      size: 24,
                    ),
                    onPressed: currentPage < splashData.length - 1 
                        ? () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        (isDarkMode ? Colors.white10 : Colors.black12).withOpacity(0.1)
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(8)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: bottomFlex,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)
                  ),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: buildDot(index: index),
                          ),
                        )
                      ),
                    ),
                    Spacer(flex: isSmallPhone ? 2 : 3),
                    SizedBox(
                      width: buttonWidth,
                      child: DefaultButton(
                        text: "Continuar",
                        press: (){
                          // Redireccionar al login screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDesktopLayout(BuildContext context) {
    // Usar colores del tema actual
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? Theme.of(context).colorScheme.surfaceVariant 
        : FPrimaryLightColor;
    
    // Controlador para el PageView
    final PageController pageController = PageController(initialPage: currentPage);
    
    // Obtener el ancho de la pantalla para ajustes responsivos
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Ajustar proporciones según el tamaño de la pantalla
    final bool isLargeScreen = screenWidth > 1400;
    final bool isMediumScreen = screenWidth > 1100 && screenWidth <= 1400;
    
    // Ajustar tamaños de fuente y espaciado según el tamaño de la pantalla
    final double titleSize = isLargeScreen ? 56 : isMediumScreen ? 48 : 40;
    final double textSize = isLargeScreen ? 28 : isMediumScreen ? 24 : 20;
    final double padding = isLargeScreen ? 60 : isMediumScreen ? 40 : 30;
    final double spacing = isLargeScreen ? 40 : isMediumScreen ? 30 : 20;
    final double buttonWidth = isLargeScreen ? 350 : isMediumScreen ? 300 : 250;
    
    return Row(
      children: [
        // Lado izquierdo - Imagen actual
        Expanded(
          flex: 1,
          child: Container(
            color: backgroundColor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Carrusel de imágenes
                PageView.builder(
                  controller: pageController,
                  onPageChanged: (value){
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index){
                    final item = splashData[index];
                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
                
                // Flechas de navegación
                Positioned(
                  left: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: isDarkMode 
                          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                          : Colors.black54,
                      size: 30,
                    ),
                    onPressed: currentPage > 0 
                        ? () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        (isDarkMode ? Colors.white10 : Colors.black12).withOpacity(0.1)
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(12)
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isDarkMode 
                          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                          : Colors.black54,
                      size: 30,
                    ),
                    onPressed: currentPage < splashData.length - 1 
                        ? () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        (isDarkMode ? Colors.white10 : Colors.black12).withOpacity(0.1)
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(12)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Lado derecho - Texto y botón
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ECOSHOPPING",
                  style: TextStyle(
                    fontSize: titleSize,
                    color: isDarkMode 
                        ? Theme.of(context).colorScheme.primary 
                        : FPrimaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: spacing),
                Text(
                  splashData[currentPage]['text']!,
                  style: TextStyle(
                    fontSize: textSize,
                    height: 1.5,
                    color: isDarkMode 
                        ? Theme.of(context).colorScheme.onBackground 
                        : Colors.black87,
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                Row(
                  children: [
                    ...List.generate(
                      splashData.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: buildDot(index: index),
                        ),
                      )
                    ),
                  ],
                ),
                SizedBox(height: spacing * 1.5),
                SizedBox(
                  width: buttonWidth,
                  child: DefaultButton(
                    text: "Continuar",
                    press: (){
                      // Redireccionar al login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //Contenedor de puntos
  AnimatedContainer buildDot({int? index}) {
    // Usar colores del tema actual
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDarkMode 
        ? Theme.of(context).colorScheme.primary 
        : FPrimaryColor;
    final inactiveColor = isDarkMode 
        ? Theme.of(context).colorScheme.surfaceVariant 
        : const Color(0xFFD8D8D8);
    
    return AnimatedContainer(
      duration: FAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}