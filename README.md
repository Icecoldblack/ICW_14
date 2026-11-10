# ICW_14: Firebase Cloud Messaging in Flutter

CSC 4360 Mobile App Development, In-Class Activity 14 (undergraduate).

A small Flutter app that receives FCM messages and uses two string data keys
to change what is on screen.

## Payload

```json
{
  "notification": { "title": "New promotion", "body": "Switch the screen to the promo asset" },
  "data": { "asset": "promo", "action": "update_ui" }
}
```

- `action` must be `update_ui`.
- `asset` must be `default` or `promo`. Anything else is rejected with a message on screen and the old title and image stay.

## Files

- `lib/main.dart`: Firebase startup, background handler, and the screen.
- `lib/fcm_service.dart`: all the FCM listeners in one class.
- `assets/images/default.png` and `promo.png`: the two images.

## Which handler runs

| App state | Handler |
| --- | --- |
| Foreground | `FirebaseMessaging.onMessage` |
| Background, user taps notification | `FirebaseMessaging.onMessageOpenedApp` |
| Terminated, user taps notification | `FirebaseMessaging.instance.getInitialMessage()` |
| Background work only, no UI | `FirebaseMessaging.onBackgroundMessage` (top level, cannot update widgets) |

## Setup

1. `flutter pub add "firebase_core:^4.0.0" "firebase_messaging:^16.0.0"`
2. `flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID` (creates `firebase_options.dart`)
3. `flutter run` on an Android emulator with Google Play services.
4. Copy the FCM token from the run log into Firebase Console, Messaging, send a test message with the custom data above.
