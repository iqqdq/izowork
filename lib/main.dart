import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/izowork_app.dart';
import 'package:izowork/services/local_storage/local_storage.dart';
import 'package:izowork/services/push_notification/push_notification.dart';
import 'package:izowork/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

final GetIt _getIt = GetIt.I;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // LOCAL STORAGE SERVICE SINGLETON
  _getIt.registerLazySingleton<LocalStorageService>(
      () => LocalStorageServiceImpl(sharedPreferences: sharedPreferences));

  // PUSH NOTIFICATION SERVICE SINGLETON
  _getIt.registerLazySingleton<PushNotificationService>(
      () => PushNotificationServiceImpl());

  // FIREBASE INIT APP
  await Firebase.initializeApp(
    name: 'Izowork',
    options: Platform.isIOS
        ? DefaultFirebaseOptions.ios
        : DefaultFirebaseOptions.android,
  ).whenComplete(() =>
      _getIt<PushNotificationService>().setupFlutterLocalNotificationsPlugin());

  // SET   ORIENTATIONS
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const IzoworkApp());
}
