import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

// Handles all Firebase Cloud Messaging listeners in one place.
class FCMService {
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onOpenedSub;

  Future<void> initialize({
    required void Function(RemoteMessage message, String source) onData,
    required void Function(String text) onStatus,
  }) async {
    final messaging = FirebaseMessaging.instance;

    // Ask for notification permission (needed on Android 13+ and iOS).
    final settings = await messaging.requestPermission();
    onStatus('Permission: ${settings.authorizationStatus.name}');

    // The device token is what you paste into Firebase Console to send a test.
    final token = await messaging.getToken();
    print('FCM token: $token');

    // 1. Foreground: app is open and visible.
    _onMessageSub = FirebaseMessaging.onMessage.listen((message) {
      onData(message, 'onMessage (foreground)');
    });

    // 2. Background: user taps a notification while app is in the background.
    _onOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onData(message, 'onMessageOpenedApp (background tap)');
    });

    // 3. Terminated: user taps a notification and the app cold starts.
    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      onData(initial, 'getInitialMessage (cold start tap)');
    }
  }

  // Stop listening when the screen is closed.
  Future<void> dispose() async {
    await _onMessageSub?.cancel();
    await _onOpenedSub?.cancel();
  }
}
