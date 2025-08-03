import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  Timer? _timer;
  final Set<String> _registeredPhones = {};
  
  InvitationCubit() : super(InvitationInitial()) {
    _loadInvitationData();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _loadInvitationData() {
    emit(InvitationLoading());
    
    // Datos de la fiesta
    final targetDate = DateTime(2025, 8, 8, 19, 0); // 8 de Agosto 2025 a las 7:00 PM
    final eventTitle = '¡ESTÁS INVITADO!';
    final eventDate = '8 de Agosto 2025';
    final eventTime = '7:00 PM';
    final eventLocation = 'Avenida Alta Luz 2001';
    final eventDescription = 'Ven a disfrutar de una noche increíble con música, comida y mucha diversión. ¡No faltes!';
    
    _calculateTimeLeft(targetDate);
    
    // Iniciar timer para actualizar el contador
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft(targetDate);
    });
  }

  void _calculateTimeLeft(DateTime targetDate) {
    // Verificar si el cubit está cerrado antes de emitir
    if (isClosed) return;
    
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    final timeLeft = difference.isNegative ? Duration.zero : difference;
    
    // Mantener el estado de confirmación si ya existe
    final currentState = state;
    final isConfirmed = currentState is InvitationLoaded ? currentState.isConfirmed : false;
    
    // Solo emitir si el cubit no está cerrado
    if (!isClosed) {
      emit(InvitationLoaded(
        targetDate: targetDate,
        timeLeft: timeLeft,
        eventTitle: '¡ESTÁS INVITADO!',
        eventDate: '8 de Agosto 2025',
        eventTime: '7:00 PM',
        eventLocation: 'Avenida Alta Luz 2001',
        eventDescription: 'Ven a disfrutar de una noche increíble con música, comida y mucha diversión. ¡No faltes!',
        isConfirmed: isConfirmed,
      ));
    }
  }

  Future<void> submitRsvp(String name, String phone) async {
    if (isClosed) return;
    emit(RsvpSubmitting());
    
    try {
      // Limpiar el número de teléfono para validación
      final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      
      // Verificar si el número ya está registrado
      if (_registeredPhones.contains(cleanPhone)) {
        if (!isClosed) {
          emit(RsvpError(message: 'Este número de teléfono ya está registrado.'));
        }
        return;
      }
      
      // Simular envío de datos
      await Future.delayed(const Duration(seconds: 1));
      
      // Verificar si el cubit sigue activo después del delay
      if (isClosed) return;
      
      // Agregar el número a la lista de registrados
      _registeredPhones.add(cleanPhone);
      
      // Aquí se procesaría el envío real del formulario
      if (!isClosed) {
        emit(RsvpSuccess(message: '¡Gracias por confirmar tu asistencia!'));
      }
      
      // No cambiar el estado, solo mantener el RsvpSuccess
      // El modal se mostrará desde el widget
    } catch (e) {
      if (!isClosed) {
        emit(RsvpError(message: 'Error al enviar la confirmación. Intenta de nuevo.'));
      }
    }
  }

  void _loadInvitationDataConfirmed() {
    // Verificar si el cubit está cerrado antes de emitir
    if (isClosed) return;
    
    final targetDate = DateTime(2025, 8, 8, 19, 0);
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    final timeLeft = difference.isNegative ? Duration.zero : difference;
    
    // Solo emitir si el cubit no está cerrado
    if (!isClosed) {
      emit(InvitationLoaded(
        targetDate: targetDate,
        timeLeft: timeLeft,
        eventTitle: '¡ESTÁS INVITADO!',
        eventDate: '8 de Agosto 2025',
        eventTime: '7:00 PM',
        eventLocation: 'Avenida Alta Luz 2001',
        eventDescription: 'Ven a disfrutar de una noche increíble con música, comida y mucha diversión. ¡No faltes!',
        isConfirmed: true,
      ));
    }
  }
}
