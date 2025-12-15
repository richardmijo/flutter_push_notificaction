# Implementación de Notificaciones Push con Flutter y Firebase (FCM)

Este proyecto demuestra cómo integrar Firebase Cloud Messaging (FCM) en una aplicación Flutter para recibir notificaciones push en primer plano (foreground) y segundo plano (background).

## 🚀 Características Implementadas

1.  **Obtención de Token FCM**: Visualización del token único del dispositivo para enviar mensajes de prueba.
2.  **Notificaciones en Segundo Plano**: Manejo de mensajes cuando la app está cerrada o minimizada.
3.  **Notificaciones en Primer Plano**: Visualización de un diálogo de alerta cuando la app está abierta y recibe un mensaje.
4.  **Configuración Multiplataforma**: Ajustes necesarios en Android (Gradle, Manifest) e iOS.

## 🛠️ Configuración Realizada

### 1. Dependencias (`pubspec.yaml`)
Se agregaron las siguientes librerías:
*   `firebase_core`: Núcleo de Firebase.
*   `firebase_messaging`: Plugin para Cloud Messaging.

### 2. Configuración de Android

#### Archivos Gradle
*   **`android/settings.gradle.kts`**: Se agregó el plugin de Google Services (`com.google.gms.google-services`).
*   **`android/app/build.gradle.kts`**: 
    *   Se aplicó el plugin `com.google.gms.google-services`.
    *   **NDK Version**: Se actualizó a `27.0.12077973` para compatibilidad.
    *   **Min SDK**: Se subió a `23` (Android 6.0) requerido por Firebase Messaging.

#### Archivo `google-services.json`
> **IMPORTANTE**: Este archivo debe ser descargado desde la consola de Firebase y colocado en `android/app/google-services.json`. Sin este archivo, la app no compilará.

### 3. Configuración de iOS (Para referencia)
*   Se debe colocar `GoogleService-Info.plist` en `ios/Runner`.
*   En Xcode, agregar la capacidad "Push Notifications" y "Background Modes" (marcando "Remote notifications").

## 📂 Estructura del Código

### `lib/services/notification_service.dart`
Esta es la clase principal que maneja toda la lógica de FCM:
*   **`initNotifications()`**: Solicita permisos y obtiene el token.
*   **`_handleBackgroundMessage()`**: Método estático que se ejecuta cuando llega una notificación y la app está cerrada.
*   **`messageStream`**: Stream personalizado para enviar mensajes recibidos en primer plano hacia la UI.

### `lib/main.dart`
*   Inicializa Firebase y el `NotificationService` en el método `main()`.
*   Escucha el `messageStream` para mostrar un `AlertDialog` con el contenido del mensaje cuando la app está en uso.
*   Muestra el **FCM Token** en la pantalla principal.

## 🧪 Cómo Probar

1.  **Ejecutar la App**:
    ```bash
    flutter run
    ```
2.  **Copiar el Token**:
    *   En la pantalla principal aparecerá el "FCM Token". Copialo.
3.  **Enviar Mensaje de Prueba**:
    *   Ve a la [Consola de Firebase](https://console.firebase.google.com/).
    *   Entra a la sección **Messaging** (Participación).
    *   Crea una nueva campaña de notificación.
    *   Ingresa Título y Texto.
    *   En la sección de destinatarios, elige **Token de registro FCM** y pega el token de tu dispositivo.
4.  **Escenarios**:
    *   **App Minimizada**: Deberías ver una notificación del sistema en la barra de estado.
    *   **App Abierta**: Deberías ver un diálogo (alert) dentro de la app con el mensaje.

---
**Clase de Programación Móvil - UIDE**
Limpio y comentado para fines educativos.
