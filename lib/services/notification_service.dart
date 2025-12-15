import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Clase para manejar las notificaciones push con Firebase Cloud Messaging (FCM).
/// Incluye inicialización, obtención de token y manejo de mensajes en diferentes estados.
class NotificationService {
  // Instancia singleton de Firebase Messaging.
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // Stream controller local para manejar mensajes en primer plano y actualizar la UI
  // Usamos broadcast para que múltiples partes de la app puedan escuchar si es necesario
  static final _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  static Stream<RemoteMessage> get messageStream =>
      _messageStreamController.stream;

  /// Método para inicializar las notificaciones.
  /// Solicita permisos y obtiene el token del dispositivo.
  static Future<void> initNotifications() async {
    // 1. Solicitar permisos (crítico para iOS y Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Imprimir el estado de los permisos para depuración
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permisos de notificaciones concedidos');
    } else {
      debugPrint('Permisos de notificaciones denegados o no determinados');
    }

    // 2. Obtener el token del dispositivo (FCM Token)
    // Este token se necesita para enviar notificaciones a este dispositivo específico
    final fcmToken = await _firebaseMessaging.getToken();

    // Mostramos el token en consola para poder copiarlo y probar
    debugPrint("========================================");
    debugPrint("FCM Token: $fcmToken");
    debugPrint("========================================");

    // En una app real, aquí enviarías el token a tu backend para guardarlo asociado al usuario

    // 3. Configurar manejadores de eventos

    // Handler para mensajes en segundo plano (cuando la app está cerrada o minimizada)
    // Debe ser una función top-level o static
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handler para mensajes en primer plano (cuando la app está abierta)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        'Mensaje recibido en primer plano: ${message.notification?.title}',
      );
      if (message.notification != null) {
        // Añadimos el mensaje al stream para que la UI pueda manejarlo
        _messageStreamController.add(message);
        // Aquí podrías mostrar un diálogo o una notificación local personalizada
        debugPrint('Cuerpo: ${message.notification?.body}');
      }
    });

    // Handler para cuando se abre la app desde una notificación cerrada
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('La app se abrió desde una notificación: ${message.data}');
      // Aquí podrías navegar a una pantalla específica
    });
  }

  /// Función top-level para manejar mensajes en segundo plano.
  /// Esta función se ejecuta en un aislamiento separado, no puede acceder al contexto UI.
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint("Manejando mensaje en segundo plano: ${message.messageId}");
    debugPrint("Título: ${message.notification?.title}");
    debugPrint("Cuerpo: ${message.notification?.body}");
  }
}
