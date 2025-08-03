import 'package:flutter/material.dart';
import '../cubit/invitation_cubit.dart';

class PartyDetailsWidget extends StatelessWidget {
  final InvitationLoaded state;
  
  const PartyDetailsWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Center(
            child: Text(
              'Detalles de la Fiesta',
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          
          // Información del evento
          _buildInfoRow(Icons.calendar_today, 'Fecha: ${state.eventDate}', isSmallScreen),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildInfoRow(Icons.access_time, 'Hora: ${state.eventTime}', isSmallScreen),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildInfoRow(Icons.location_on, 'Lugar: ${state.eventLocation}', isSmallScreen),
          
          SizedBox(height: isSmallScreen ? 20 : 24),
          
          // Descripción
          Text(
            state.eventDescription,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isSmallScreen) {
    return Row(
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 18 : 20,
          color: Colors.grey[600],
        ),
        SizedBox(width: isSmallScreen ? 10 : 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
} 