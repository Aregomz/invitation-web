import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/invitation_cubit.dart';
import '../widgets/header_widget.dart';
import '../widgets/countdown_widget.dart';
import '../widgets/rsvp_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/requirements_widget.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvitationCubit(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: BlocBuilder<InvitationCubit, InvitationState>(
                builder: (context, state) {
                  if (state is InvitationLoading) {
                    return const LoadingWidget();
                  }
                  
                  if (state is InvitationLoaded) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          // Header con animaciones
                          const HeaderWidget(),
                          
                          const SizedBox(height: 20),
                          
                          // Contador regresivo
                          const CountdownWidget(),
                          
                          const SizedBox(height: 20),
                          
                          // Mostrar requisitos siempre
                          const RequirementsWidget(),
                          
                          const SizedBox(height: 20),
                          
                          // Formulario RSVP
                          const RsvpWidget(),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }
                  
                  return const Center(
                    child: Text('Error al cargar la invitación'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
} 