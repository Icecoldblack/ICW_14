# CSC 4360 Activity 14 Reflection: Firebase Cloud Messaging

## 1. Environment

* Device: Android emulator Pixel 9 Pro (sdk gphone16k x86_64, Android 16)
* Firebase project: icw-14
* Package: edu.gsu.uyiosa.icw_14
* firebase_core 4.15.2, firebase_messaging 16.7.1
* Notification permission: authorized (recorded once)

## 2. Valid Payload

```json
{
  "notification": {
    "title": "New promotion",
    "body": "Switch the screen to the promo asset"
  },
  "data": {
    "asset": "promo",
    "action": "update_ui"
  }
}
```

I sent this from Firebase Console notification campaigns targeting the app, not a token test send, so each delivery took 1 to 3 minutes.

## 3. Results

| Test | Expected handler/result | Observed | Status | Evidence |
|---|---|---|---|---|
| T1 foreground | onMessage updates title and image | onMessage (foreground), title New promotion, orange promo image, count 1 | PASS | screenshots/T1_foreground.jpg |
| T2 background tap | onMessageOpenedApp updates UI | onMessageOpenedApp (background tap), count 2, promo image; log also showed onBackgroundMessage ran in background isolate | PASS | screenshots/T2a_onBackgroundMessage_log.jpg, screenshots/T2b_notification.jpg, screenshots/T2c_background_tap.jpg |
| T3 cold start | getInitialMessage updates UI | T3_RESULT | T3_RESULT | T3_RESULT |
| T4 invalid payload (asset=unknown, foreground) | Rejected with diagnostic text, previous UI kept | T4_RESULT | T4_RESULT | T4_RESULT |

## 4. Reflection

**(a) Setup and payload.** I used flutterfire configure with only the Android target and created the project icw-14. My first ID, icw14, was rejected because it was under 6 characters. The payload uses two keys. action must equal update_ui or the app ignores it. asset picks from a fixed map, {default, promo}, that points to bundled images.

**(b) Lifecycle and evidence.** onMessage runs while the app is open (T1). onMessageOpenedApp runs when the user taps a notification while the app is in the background (T2). getInitialMessage returns the message that launched a terminated app (T3). onBackgroundMessage is a top level function that runs in a separate isolate with no widget tree, so it can only log. It cannot call setState.

**(c) Validation and next step.** In T4 the app rejects the unknown asset, shows diagnostic text, and keeps the previous title and image while the receipt metadata still updates. A real failure I hit was getToken throwing "FCM Registration failed" (FirebaseInstallationsException, Service unavailable). The emulator was in airplane mode and its clock was days behind. Turning off airplane mode fixed it. As an improvement, I would show a "no network, messaging unavailable" message and retry getToken when connectivity returns. You could see it work when the error clears without restarting the app.

## 5. Limitations

* I tested on one emulator only.
* Console campaigns are slower than token test sends, so testing took longer.
* AI assistance disclosure: Claude helped write the code, run the tests, and draft this reflection.
