import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/invitation_cubit.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationCubit, InvitationState>(
      builder: (context, state) {
        if (state is InvitationLoaded) {
          final days = state.timeLeft.inDays;
          final hours = state.timeLeft.inHours % 24;
          final minutes = state.timeLeft.inMinutes % 60;
          final seconds = state.timeLeft.inSeconds % 60;

          final screenWidth = MediaQuery.of(context).size.width;
          final isSmallScreen = screenWidth < 600;

          return AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Título del countdown
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                                boxShadow: [
                                                                     BoxShadow(
                                     color: Colors.amber.withOpacity(0.5 + (_glowAnimation.value * 0.3)),
                                     blurRadius: 15 + (_glowAnimation.value * 10),
                                     spreadRadius: 2,
                                   ),
                                ],
                              ),
                              child: Text(
                                'CUENTA REGRESIVA',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Cards de tiempo
                      isSmallScreen
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildAnimatedTimeCard(
                                        days.toString().padLeft(2, '0'),
                                        'DÍAS',
                                        isSmallScreen,
                                        0,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildAnimatedTimeCard(
                                        hours.toString().padLeft(2, '0'),
                                        'HORAS',
                                        isSmallScreen,
                                        1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildAnimatedTimeCard(
                                        minutes.toString().padLeft(2, '0'),
                                        'MINUTOS',
                                        isSmallScreen,
                                        2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildAnimatedTimeCard(
                                        seconds.toString().padLeft(2, '0'),
                                        'SEGUNDOS',
                                        isSmallScreen,
                                        3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: _buildAnimatedTimeCard(
                                    days.toString().padLeft(2, '0'),
                                    'DÍAS',
                                    isSmallScreen,
                                    0,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildAnimatedTimeCard(
                                    hours.toString().padLeft(2, '0'),
                                    'HORAS',
                                    isSmallScreen,
                                    1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildAnimatedTimeCard(
                                    minutes.toString().padLeft(2, '0'),
                                    'MINUTOS',
                                    isSmallScreen,
                                    2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildAnimatedTimeCard(
                                    seconds.toString().padLeft(2, '0'),
                                    'SEGUNDOS',
                                    isSmallScreen,
                                    3,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAnimatedTimeCard(String value, String label, bool isSmallScreen, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.8 + (animationValue * 0.2),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
                boxShadow: [
                                     BoxShadow(
                     color: Colors.amber.withOpacity(0.4),
                     blurRadius: 12,
                     spreadRadius: 2,
                     offset: const Offset(0, 4),
                   ),
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
                                 border: Border.all(
                   color: Colors.amber.withOpacity(0.6),
                   width: 2,
                 ),
              ),
              child: Column(
                children: [
                  // Valor con efecto de brillo
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
                      value,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  const SizedBox(height: 8),
                  // Label
                                     Text(
                     label,
                     style: TextStyle(
                       fontSize: isSmallScreen ? 12 : 14,
                       fontWeight: FontWeight.w600,
                       color: Colors.amber[300],
                       letterSpacing: 0.5,
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