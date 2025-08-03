import 'package:flutter/material.dart';

class RequirementsWidget extends StatefulWidget {
  const RequirementsWidget({super.key});

  @override
  State<RequirementsWidget> createState() => _RequirementsWidgetState();
}

class _RequirementsWidgetState extends State<RequirementsWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
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
        child: Container(
          margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
            boxShadow: [
                             BoxShadow(
                 color: Colors.amber.withOpacity(0.3),
                 blurRadius: 15,
                 spreadRadius: 2,
                 offset: const Offset(0, 8),
               ),
              BoxShadow(
                color: Colors.amber.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.amber.withOpacity(0.6),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título con efecto de brillo
              Center(
                child:                   ShaderMask(
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
                    'Requisitos para la Fiesta',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                                             shadows: [
                         Shadow(
                           color: Colors.amber[800]!,
                           offset: const Offset(1, 1),
                           blurRadius: 2,
                         ),
                       ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              
              // Lista de requisitos animados
              _buildAnimatedRequirementItem(
                Icons.local_bar,
                'Traer tu botella favorita',
                isSmallScreen,
                0,
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              _buildAnimatedRequirementItem(
                Icons.celebration,
                'Ganas de pistear',
                isSmallScreen,
                1,
              ),
              
              SizedBox(height: isSmallScreen ? 20 : 24),
              
              // Mensaje adicional con efecto especial
              _buildSpecialMessage(isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedRequirementItem(IconData icon, String text, bool isSmallScreen, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 300)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - animationValue), 0),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
                border: Border.all(
                  color: Colors.amber.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: isSmallScreen ? 18 : 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.amber[300],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecialMessage(bool isSmallScreen) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.9 + (animationValue * 0.1),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
                 border: Border.all(
                   color: Colors.amber[600]!,
                   width: 2,
                 ),
                boxShadow: [
                                     BoxShadow(
                     color: Colors.amber.withOpacity(0.3),
                     blurRadius: 8,
                     spreadRadius: 1,
                   ),
                ],
              ),
              child: Row(
                children: [
                                     Icon(
                     Icons.info_outline,
                     color: Colors.amber[300],
                     size: isSmallScreen ? 20 : 24,
                   ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Expanded(
                    child: Text(
                      'Confirma tu asistencia para ver los detalles completos de la fiesta',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.amber[300],
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 