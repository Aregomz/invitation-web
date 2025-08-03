import 'package:flutter/material.dart';
import '../cubit/invitation_cubit.dart';

class DetailsModalWidget extends StatefulWidget {
  final InvitationLoaded state;
  
  const DetailsModalWidget({
    super.key,
    required this.state,
  });

  @override
  State<DetailsModalWidget> createState() => _DetailsModalWidgetState();
}

class _DetailsModalWidgetState extends State<DetailsModalWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeInOut,
    ));

    _scaleController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black,
              boxShadow: [
                                 BoxShadow(
                   color: Colors.amber.withOpacity(0.4),
                   blurRadius: 25,
                   spreadRadius: 5,
                   offset: const Offset(0, 10),
                 ),
                BoxShadow(
                  color: Colors.amber.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header con confeti animado
                _buildAnimatedHeader(isSmallScreen),
                
                SizedBox(height: isSmallScreen ? 20 : 24),
                
                // Título de detalles con efecto de brillo
                _buildAnimatedTitle(isSmallScreen),
                
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                // Información del evento animada
                _buildAnimatedInfoRow(Icons.calendar_today, 'Fecha: ${widget.state.eventDate}', isSmallScreen, 0),
                SizedBox(height: isSmallScreen ? 8 : 12),
                _buildAnimatedInfoRow(Icons.access_time, 'Hora: ${widget.state.eventTime}', isSmallScreen, 1),
                SizedBox(height: isSmallScreen ? 8 : 12),
                _buildAnimatedInfoRow(Icons.location_on, 'Lugar: ${widget.state.eventLocation}', isSmallScreen, 2),
                
                // Solo mostrar descripción si no está vacía
                if (widget.state.eventDescription.isNotEmpty) ...[
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  
                  // Descripción
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Text(
                      widget.state.eventDescription,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.orange[800],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                
                SizedBox(height: isSmallScreen ? 20 : 24),
                
                // Botón para descargar imagen animado
                _buildAnimatedDownloadButton(isSmallScreen),
                
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                // Botón para cerrar animado
                _buildAnimatedCloseButton(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(bool isSmallScreen) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.8 + (animationValue * 0.2),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                             decoration: BoxDecoration(
                 color: Colors.black,
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: Colors.amber[600]!),
                boxShadow: [
                                     BoxShadow(
                     color: Colors.amber.withOpacity(0.3),
                     blurRadius: 8,
                     spreadRadius: 1,
                   ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _confettiAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _confettiAnimation.value * 2 * 3.14159,
                        child: Icon(
                          Icons.celebration,
                          size: isSmallScreen ? 24 : 28,
                          color: Colors.amber[600],
                        ),
                      );
                    },
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
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
                      '¡Confirmado!',
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
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  AnimatedBuilder(
                    animation: _confettiAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: -_confettiAnimation.value * 2 * 3.14159,
                        child: Icon(
                          Icons.celebration,
                          size: isSmallScreen ? 24 : 28,
                          color: Colors.amber[600],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle(bool isSmallScreen) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
                          child: ShaderMask(
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
                'Detalles de la Fiesta',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
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
        );
      },
    );
  }

  Widget _buildAnimatedInfoRow(IconData icon, String text, bool isSmallScreen, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - animationValue), 0),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                                 color: Colors.black,
                 border: Border.all(
                   color: Colors.amber.withOpacity(0.6),
                   width: 2,
                 ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                                       decoration: BoxDecoration(
                     color: Colors.amber[600],
                     borderRadius: BorderRadius.circular(6),
                   ),
                    child: Icon(
                      icon,
                      size: isSmallScreen ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 10 : 12),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.amber[300],
                        fontWeight: FontWeight.w600,
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

  Widget _buildAnimatedDownloadButton(bool isSmallScreen) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.8 + (animationValue * 0.2),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
                boxShadow: [
                                     BoxShadow(
                     color: Colors.amber.withOpacity(0.3),
                     blurRadius: 12,
                     spreadRadius: 2,
                     offset: const Offset(0, 4),
                   ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _downloadImage(context),
                icon: Icon(
                  Icons.download,
                  size: isSmallScreen ? 18 : 20,
                ),
                label: Text(
                  'Descargar Invitación',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 24,
                    vertical: isSmallScreen ? 12 : 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCloseButton(bool isSmallScreen) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.9 + (animationValue * 0.1),
          child: Opacity(
            opacity: animationValue,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 8 : 12,
                ),
              ),
                              child: Text(
                  'Cerrar',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.amber[300],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ),
          ),
        );
      },
    );
  }

  void _downloadImage(BuildContext context) {
    // Aquí se implementaría la lógica de descarga
    // Por ahora solo mostramos un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.download_done,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 12),
            Text('Invitación descargada'),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
} 