import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24),
            padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black,
              boxShadow: [
                                 BoxShadow(
                   color: Colors.amber.withOpacity(0.3),
                   blurRadius: 20,
                   spreadRadius: 5,
                   offset: const Offset(0, 10),
                 ),
                BoxShadow(
                  color: Colors.amber.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                                 // Iconos de confeti animados (reducidos)
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     TweenAnimationBuilder<double>(
                       duration: const Duration(milliseconds: 800),
                       tween: Tween(begin: 0.0, end: 1.0),
                       builder: (context, value, child) {
                         return Transform.rotate(
                           angle: value * 2 * 3.14159,
                           child: Opacity(
                             opacity: value,
                             child: Icon(
                               Icons.celebration,
                               size: isSmallScreen ? 20 : 24,
                               color: Colors.amber[600],
                             ),
                           ),
                         );
                       },
                     ),
                   ],
                 ),
                
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                // Título principal con efecto de gradiente
                                 ShaderMask(
                   shaderCallback: (bounds) {
                     return LinearGradient(
                       colors: [
                         Colors.amber[300]!,
                         Colors.amber[600]!,
                         Colors.amber[800]!,
                       ],
                     ).createShader(bounds);
                   },
                  child: Text(
                    '¡ESTÁS INVITADO!',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                                             shadows: [
                         Shadow(
                           color: Colors.amber[800]!,
                           offset: const Offset(2, 2),
                           blurRadius: 4,
                         ),
                       ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 12 : 16),
                
                // Subtítulo con animación
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 18,
                            color: Colors.amber[300],
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                                 // Iconos de confeti inferiores (reducidos)
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     TweenAnimationBuilder<double>(
                       duration: const Duration(milliseconds: 1000),
                       tween: Tween(begin: 0.0, end: 1.0),
                       builder: (context, value, child) {
                         return Transform.rotate(
                           angle: -value * 2 * 3.14159,
                           child: Opacity(
                             opacity: value,
                             child: Icon(
                               Icons.celebration,
                               size: isSmallScreen ? 20 : 24,
                               color: Colors.amber[600],
                             ),
                           ),
                         );
                       },
                     ),
                   ],
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 