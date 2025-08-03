import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/invitation_cubit.dart';
import 'details_modal_widget.dart';

class RsvpWidget extends StatefulWidget {
  const RsvpWidget({super.key});

  @override
  State<RsvpWidget> createState() => _RsvpWidgetState();
}

class _RsvpWidgetState extends State<RsvpWidget>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Set<String> _submittedPhones = {};
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonAnimation;

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
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    _fadeController.forward();
    _buttonController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      
      // Verificar si el número ya fue enviado en esta sesión
      if (_submittedPhones.contains(cleanPhone)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este número ya fue enviado en esta sesión'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      context.read<InvitationCubit>().submitRsvp(
        _nameController.text.trim(),
        _phoneController.text.trim(),
      );
      
      // Agregar a la lista de números enviados en esta sesión
      _submittedPhones.add(cleanPhone);
      
      // Limpiar campos
      _nameController.clear();
      _phoneController.clear();
    }
  }

  // Validación para el nombre
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    if (value.trim().length > 50) {
      return 'El nombre es demasiado largo';
    }
    
    // Validar que solo contenga letras, espacios y algunos caracteres especiales
    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return 'El nombre solo puede contener letras y espacios';
    }
    
    // Validar que no contenga números
    if (RegExp(r'\d').hasMatch(value)) {
      return 'El nombre no puede contener números';
    }
    
    return null;
  }

  // Validación para el número de teléfono
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu número de celular';
    }
    
    // Remover espacios y caracteres especiales para validación
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Validar que solo contenga números
    if (!RegExp(r'^\d+$').hasMatch(cleanPhone)) {
      return 'El número solo puede contener dígitos';
    }
    
    // Validar longitud (10 dígitos para México)
    if (cleanPhone.length != 10) {
      return 'El número debe tener 10 dígitos';
    }
    
    // Verificar si el número ya fue enviado en esta sesión
    if (_submittedPhones.contains(cleanPhone)) {
      return 'Este número ya fue registrado en esta sesión';
    }
    
    return null;
  }

  void _showDetailsModal(BuildContext context) {
    // Crear un estado con los datos de la fiesta para el modal
    final invitationState = InvitationLoaded(
      targetDate: DateTime(2025, 8, 8, 19, 0),
      timeLeft: Duration.zero, // No es importante para el modal
      eventTitle: '¡ESTÁS INVITADO!',
      eventDate: '8 de Agosto 2025',
      eventTime: '7:00 PM',
      eventLocation: 'Avenida Alta Luz 2001',
      eventDescription: '',
      isConfirmed: true,
    );
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return DetailsModalWidget(state: invitationState);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvitationCubit, InvitationState>(
      listener: (context, state) {
        if (state is RsvpSuccess) {
          // Mostrar modal con detalles en lugar de snackbar
          _showDetailsModal(context);
        } else if (state is RsvpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<InvitationCubit, InvitationState>(
        builder: (context, state) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isSmallScreen = screenWidth < 600;
          final isLoading = state is RsvpSubmitting;
          
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título con efecto de brillo
                      Center(
                        child:                          ShaderMask(
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
                            'Confirmar Asistencia',
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
                      
                      // Campo de nombre animado
                      _buildAnimatedTextField(
                        controller: _nameController,
                        enabled: !isLoading,
                        textCapitalization: TextCapitalization.words,
                        hintText: 'Tu nombre',
                        validator: _validateName,
                        isSmallScreen: isSmallScreen,
                        index: 0,
                      ),
                      
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      
                      // Campo de teléfono animado
                      _buildAnimatedTextField(
                        controller: _phoneController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        hintText: 'Número de celular (10 dígitos)',
                        validator: _validatePhone,
                        isSmallScreen: isSmallScreen,
                        index: 1,
                      ),
                      
                      SizedBox(height: isSmallScreen ? 20 : 24),
                      
                      // Botón de envío animado
                      _buildAnimatedButton(isLoading, isSmallScreen),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required bool enabled,
    required String hintText,
    required String? Function(String?) validator,
    required bool isSmallScreen,
    required int index,
    TextCapitalization? textCapitalization,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 300)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - animationValue), 0),
          child: Opacity(
            opacity: animationValue,
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.amber[400]),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.amber[400]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.amber[400]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.amber[300]!, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: isSmallScreen ? 16 : 18,
                ),
                prefixIcon: Icon(
                  index == 0 ? Icons.person : Icons.phone,
                  color: Colors.amber[300],
                ),
              ),
              style: TextStyle(color: Colors.white), // Added white text color for input
              validator: validator,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton(bool isLoading, bool isSmallScreen) {
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
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16 : 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send,
                            size: isSmallScreen ? 18 : 20,
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text(
                            'Confirmar Asistencia',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
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
} 