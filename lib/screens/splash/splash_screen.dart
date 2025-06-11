import 'package:flutter/material.dart';
import '../../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: 'assets/images/splash_2.png',
      title: 'BIENVENIDO A ECOSHOPPING',
      description: 'Descubre una nueva forma de comprar productos ecológicos y sostenibles.',
      icon: Icons.eco,
      color: Colors.green,
    ),
    OnboardingPage(
      image: 'assets/images/freepik__upload__2400.png',
      title: 'PRODUCTOS DE CALIDAD',
      description: 'Encuentra los mejores productos de vendedores verificados en nuestra plataforma.',
      icon: Icons.verified,
      color: Colors.blue,
    ),
    OnboardingPage(
      image: 'assets/images/splash_3.png',
      title: 'COMPRA FÁCIL Y SEGURA',
      description: 'Realiza tus compras de forma segura con nuestro sistema de pagos protegido.',
      icon: Icons.security,
      color: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isDesktop 
            ? _buildDesktopLayout() 
            : isTablet 
                ? _buildTabletLayout() 
                : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Column(
      children: [
        // Header con logo
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Text(
            'ECOSHOPPING',
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 2,
            ),
          ),
        ),
        
        // PageView con las páginas del onboarding
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildMobilePage(_pages[index]);
                },
              ),
              
              // Botones de navegación
              Positioned(
                left: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _currentPage > 0
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _previousPage,
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _currentPage < _pages.length - 1
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _nextPage,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
        
        // Indicadores de página
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _pages.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              width: _currentPage == index ? screenWidth * 0.06 : screenWidth * 0.02,
              height: screenWidth * 0.02,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(screenWidth * 0.01),
              ),
            ),
          ),
        ),
        
        SizedBox(height: screenHeight * 0.05),
        
        // Botón Continuar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: SizedBox(
            width: double.infinity,
            height: screenHeight * 0.07,
            child: ElevatedButton(
              onPressed: _goToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Text(
                'CONTINUAR',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Row(
      children: [
        // Panel izquierdo - Información y navegación
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Text(
                  'ECOSHOPPING',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 3,
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Contenido de la página actual
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildDesktopContent(_pages[_currentPage]),
                ),
                
                const SizedBox(height: 60),
                
                // Indicadores y navegación
                Row(
                  children: [
                    // Indicadores de página
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: _currentPage == index ? 40 : 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Botones de navegación
                    Row(
                      children: [
                        if (_currentPage > 0)
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _previousPage,
                              icon: Icon(
                                Icons.arrow_back,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        
                        if (_currentPage < _pages.length - 1)
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _nextPage,
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Botón Continuar
                SizedBox(
                  width: 300,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _goToLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'CONTINUAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Panel derecho - Imagen
        Expanded(
          flex: 3,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _pages[_currentPage].color.withOpacity(0.1),
                  _pages[_currentPage].color.withOpacity(0.2),
                ],
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(_currentPage),
                  padding: const EdgeInsets.all(60),
                  child: Image.asset(
                    _pages[_currentPage].image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(80),
                        decoration: BoxDecoration(
                          color: _pages[_currentPage].color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _pages[_currentPage].icon,
                          size: 200,
                          color: _pages[_currentPage].color,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopContent(OnboardingPage page) {
    return Column(
      key: ValueKey(page.title),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          page.title,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          page.description,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Column(
      children: [
        // Header con logo
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Text(
            'ECOSHOPPING',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 2,
            ),
          ),
        ),
        
        // Contenido principal
        Expanded(
          child: Row(
            children: [
              // Imagen (lado izquierdo)
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _pages[_currentPage].color.withOpacity(0.1),
                        _pages[_currentPage].color.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(_currentPage),
                        padding: const EdgeInsets.all(40),
                        child: Image.asset(
                          _pages[_currentPage].image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: _pages[_currentPage].color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _pages[_currentPage].icon,
                                size: 120,
                                color: _pages[_currentPage].color,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Contenido de texto (lado derecho)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _pages[_currentPage].title,
                          key: ValueKey(_pages[_currentPage].title),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Descripción
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _pages[_currentPage].description,
                          key: ValueKey(_pages[_currentPage].description),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Indicadores y navegación
                      Row(
                        children: [
                          // Indicadores de página
                          Row(
                            children: List.generate(
                              _pages.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == index ? 32 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Botones de navegación
                          Row(
                            children: [
                              if (_currentPage > 0)
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: _previousPage,
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              
                              if (_currentPage < _pages.length - 1)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: _nextPage,
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Botón Continuar
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _goToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'CONTINUAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildMobilePage(OnboardingPage page) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade50,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  page.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            page.color.withOpacity(0.1),
                            page.color.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.08),
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: screenWidth * 0.3,
                            color: page.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.05),
          
          // Título
          Text(
            page.title,
            style: TextStyle(
              fontSize: screenWidth * 0.065,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Descripción
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Text(
              page.description,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(height: screenHeight * 0.05),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String image;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}