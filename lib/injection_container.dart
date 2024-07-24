import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/services/services.dart';

final sl = GetIt.instance;
final dio = _initializeDio();

Future initializeDependencies() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // Services
  sl.registerLazySingleton<WebServiceInterface>(() => WebServiceImpl(dio: dio));

  sl.registerLazySingleton<FileDownloadServiceInterface>(
      () => FileDownloadServiceImpl(dio: dio));

  // Repositories
  sl.registerLazySingleton<AnalyticsRepositoryInterface>(
      () => AnalyticsRepositoryImpl());

  sl.registerLazySingleton<AuthorizationRepositoryInterface>(
      () => AuthorizationRepositoryImpl());

  sl.registerLazySingleton<ChatRepositoryInterface>(() => ChatRepositoryImpl());

  sl.registerLazySingleton<CompaniesRepositoryInterface>(
      () => CompaniesRepositoryImpl());

  sl.registerLazySingleton<CompanyRepositoryInterface>(
      () => CompanyRepositoryImpl());

  sl.registerLazySingleton<ContactRepositoryInterface>(
      () => ContactRepositoryImpl());

  sl.registerLazySingleton<DealRepositoryInterface>(() => DealRepositoryImpl());

  sl.registerLazySingleton<DialogRepositoryInterface>(
      () => DialogRepositoryImpl());

  sl.registerLazySingleton<DocumentRepositoryInterface>(
      () => DocumentRepositoryImpl());

  sl.registerLazySingleton<LocalStorageRepositoryInterface>(
      () => LocalStorageRepositoryImpl(sharedPreferences: sharedPreferences));

  sl.registerLazySingleton<NewsRepositoryInterface>(() => NewsRepositoryImpl());

  sl.registerLazySingleton<NotificationRepositoryInterface>(
      () => NotificationRepositoryImpl());

  sl.registerLazySingleton<ObjectRepositoryInterface>(
      () => ObjectRepositoryImpl());

  sl.registerLazySingleton<OfficeRepositoryInterface>(
      () => OfficeRepositoryImpl());

  sl.registerLazySingleton<PhaseRepositoryInterface>(
      () => PhaseRepositoryImpl());

  sl.registerLazySingleton<ProductRepositoryInterface>(
      () => ProductRepositoryImpl());

  sl.registerLazySingleton<TaskRepositoryInterface>(() => TaskRepositoryImpl());

  sl.registerLazySingleton<TraceRepositoryInterface>(
      () => TraceRepositoryImpl());

  sl.registerLazySingleton<UserRepositoryInterface>(() => UserRepositoryImpl());
}

Dio _initializeDio() {
  final dio = Dio();
  final talker = TalkerFlutter.init();

  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printRequestData: true,
        printResponseHeaders: false,
        printResponseMessage: true,
        printResponseData: true,
        requestPen: AnsiPen()..blue(),
        responsePen: AnsiPen()..green(),
        errorPen: AnsiPen()..red(),
      ),
    ),
  );

  return dio;
}
