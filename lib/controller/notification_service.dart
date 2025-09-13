import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServiceFb {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// ✅ هاندلر للرسائل في الخلفية
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("📩 رسالة في الخلفية: ${message.messageId}");
  }

  /// ✅ تهيئة الإشعارات
  static Future<void> init() async {
    // طلب صلاحيات (مهم جداً في iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 حالة الإذن: ${settings.authorizationStatus}');

    // جلب التوكن (Device Token)
    String? token = await _fcm.getToken();
    print("✅ FCM Token: $token");

    // الرسائل أثناء عمل التطبيق (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 رسالة في الـ Foreground: ${message.notification?.title}");
    });

    // الرسائل عند فتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 تم فتح التطبيق من إشعار: ${message.notification?.title}");
    });
  }
}
