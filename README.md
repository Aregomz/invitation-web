# Invitation App

Una aplicación web de invitaciones de fiestas construida con Flutter.

## Características

- Diseño responsivo
- Animaciones elegantes
- Formulario de RSVP con validaciones
- Modal con detalles de la fiesta
- Tema negro y dorado

## Desarrollo local

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run -d chrome

# Construir para web
flutter build web --release

# Servir archivos construidos
cd build/web && python3 -m http.server 8080
```

## Despliegue en Railway

1. Conecta tu repositorio a Railway
2. Railway detectará automáticamente la configuración
3. El despliegue se realizará automáticamente

## Tecnologías utilizadas

- Flutter
- flutter_bloc para state management
- Animaciones personalizadas
- Diseño responsivo
