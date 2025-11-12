import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/firebase_options.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/screens/message/logic/socket.dart';
import 'package:laundry_customer/screens/message/message.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';

// @pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Only setup notifications if user has granted permission
  final notificationsEnabled = Hive.box(AppHSC.appSettingsBox).get('notifications_enabled', defaultValue: false);
  if (notificationsEnabled!=null) {
    await setupFlutterNotifications();
    showFlutterNotification(message);
  }
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> _firebaseMessagingForgroundHandler() async {
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint(message.data.toString());
    debugPrint(message.toString());
    debugPrint('Handling a ForeGround message ${message.messageId}');
    debugPrint('Handling a ForeGround message ${message.notification}');
    // Only show notification if user has enabled them
    final notificationsEnabled = Hive.box(AppHSC.appSettingsBox).get('notifications_enabled', defaultValue: false);
    if (notificationsEnabled!=null) {
      showFlutterNotification(message);
    }
  });
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  if (message.data['type'] == 'Conversetion') {
    // Your navigation logic here
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // REMOVED: Automatic iOS permission request
  // This was the main issue - requesting permissions without user consent

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@drawable/ic_stat_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: false, // Don't request automatically
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveLocalNotification,
    onDidReceiveNotificationResponse: onSelectNotification,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

// NEW: Function to request notification permissions when user opts in
Future<bool> requestNotificationPermission() async {
  if (Platform.isIOS) {
    // Request iOS permissions
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    // Also request local notification permissions
    final localPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await localPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    final granted = notificationSettings.authorizationStatus == AuthorizationStatus.authorized ||
        notificationSettings.authorizationStatus == AuthorizationStatus.provisional;
    
    // Save permission status
    await Hive.box(AppHSC.appSettingsBox).put('notifications_enabled', granted);
    
    return granted;
  } else if (Platform.isAndroid) {
    // For Android 13+, request permission
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    final granted = notificationSettings.authorizationStatus == AuthorizationStatus.authorized;
    await Hive.box(AppHSC.appSettingsBox).put('notifications_enabled', granted);
    
    return granted;
  }
  
  return false;
}

Future<void> onSelectNotification(
  NotificationResponse notificationResponse,
) async {
  // Your navigation logic here
}

Future<void> onDidReceiveLocalNotification(
  NotificationResponse notificationResponse,
) async {
  // Your navigation logic here
}

void showFlutterNotification(RemoteMessage message) {
  final String combinedPayload =
      '${message.data['orderId']}_${message.data['senderId']}_${message.data['receiverId']}';
  final RemoteNotification? notification = message.notification;
  final AndroidNotification? android = message.notification?.android;
  final AppleNotification? iOS = message.notification?.apple;
  if (notification != null && (android != null || iOS != null) && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/ic_stat_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: combinedPayload,
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // } else if (Platform.isIOS) {
  //   await Firebase.initializeApp();
  // }
  
  // Initialize notifications WITHOUT requesting permissions
  // await setupFlutterNotifications();
  
  // Background message handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Forground message handler
  // _firebaseMessagingForgroundHandler();

  // REMOVED: Automatic token retrieval
  // Only get token after user grants permission
  
  await Hive.initFlutter();
  await Hive.openBox(AppHSC.appSettingsBox);
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.cartBox);
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  Future<void> launchApp() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    handleMessage(initialMessage);
  }

  @override
  void initState() {
    launchApp();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('App is resumed');
      }
    } else if (state == AppLifecycleState.paused) {
      if (kDebugMode) {
        print('app is paused');
      }
    } else if (state == AppLifecycleState.inactive) {
      if (kDebugMode) {
        print('inactive');
      }
    } else if (state == AppLifecycleState.detached) {
      if (kDebugMode) {
        print('app is detached');
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final playerID = ref.watch(onesignalDeviceIDProvider);
    if (playerID == '') {
      // getPlayerID(ref);
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
          builder: (BuildContext context, Box appSettingsBox, Widget? child) {
            final selectedLocal = appSettingsBox.get(AppHSC.appLocal);
            print(selectedLocal);
            return MaterialApp(
              title: 'Laundry',
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                FormBuilderLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                if (selectedLocal == null || selectedLocal == '') {
                  appSettingsBox.put(AppHSC.appLocal, 'ar');
                  return const Locale('ar');
                }
                return const Locale('ar');
              },
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
              ],
              theme: ThemeData(
                fontFamily: "Cairo",
              ),
              navigatorKey: ContextLess.navigatorkey,
              onGenerateRoute: (settings) => generatedRoutes(settings),
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.splash,
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}