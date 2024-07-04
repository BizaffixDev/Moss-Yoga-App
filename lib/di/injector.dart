import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/app/app_config.dart';
import 'package:moss_yoga/app/utils/preference_manager.dart';
import 'package:moss_yoga/data/data_sources/dual_login_data_source.dart';
import 'package:moss_yoga/data/data_sources/firebase_messaging_data_source.dart';
import 'package:moss_yoga/data/data_sources/guide_data_sources.dart';
import 'package:moss_yoga/data/data_sources/help_support_data_source.dart';
import 'package:moss_yoga/data/data_sources/home_data_source.dart';
import 'package:moss_yoga/data/data_sources/login_data_soruce.dart';
import 'package:moss_yoga/data/data_sources/my_classes_student_data_source.dart';
import 'package:moss_yoga/data/data_sources/my_teachers_data_source.dart';
import 'package:moss_yoga/data/data_sources/notification_student_data_souce.dart';
import 'package:moss_yoga/data/data_sources/payment_data_source.dart';
import 'package:moss_yoga/data/data_sources/student_account_data_source.dart';
import 'package:moss_yoga/data/data_sources/switch_screen_data_source.dart';
import 'package:moss_yoga/data/data_sources/teacher_data_sources/earning_teacher_data_source.dart';
import 'package:moss_yoga/data/data_sources/teacher_data_sources/my_classes_teacher_data_sources.dart';
import 'package:moss_yoga/data/data_sources/teacher_data_sources/teacher_home_data_sources.dart';
import 'package:moss_yoga/data/data_sources/on_demand_student_data_source.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';

import 'package:moss_yoga/data/network/rest_api_client.dart';
import 'package:moss_yoga/data/network/service_config_logger.dart';
import 'package:moss_yoga/data/repositories/dual_login_repository.dart';
import 'package:moss_yoga/data/repositories/firebase_messaging_repository.dart';
import 'package:moss_yoga/data/repositories/guide_repository.dart';
import 'package:moss_yoga/data/repositories/help_support_repository.dart';
import 'package:moss_yoga/data/repositories/home_repository.dart';
import 'package:moss_yoga/data/repositories/my_classes_student_repository.dart';
import 'package:moss_yoga/data/repositories/my_teachers_repository.dart';
import 'package:moss_yoga/data/repositories/notification_student_repository.dart';
import 'package:moss_yoga/data/repositories/payment_data_repository.dart';
import 'package:moss_yoga/data/repositories/student_account_data_repository.dart';
import 'package:moss_yoga/data/repositories/switch_screen_repository.dart';
import 'package:moss_yoga/data/repositories/teacher_repositories/earning_teacher_repository.dart';
import 'package:moss_yoga/data/repositories/teacher_repositories/teacher_account_data_repository.dart';
import 'package:moss_yoga/data/repositories/teacher_repositories/teacher_home_repository.dart';
import 'package:moss_yoga/data/repositories/on_demand_student_repository.dart';

import '../data/data_sources/chronic_data_source.dart';
import '../data/data_sources/physical_data_source.dart';
import '../data/data_sources/teacher_data_sources/notification_teacher_data_source.dart';
import '../data/data_sources/teacher_data_sources/on_demand_teacher_data_source.dart';
import '../data/data_sources/teacher_data_sources/teacher_account_data_source.dart';
import '../data/google_sign_in.dart';
import '../data/repositories/chronic_data_repository.dart';
import '../data/repositories/login_data_repository.dart';
import '../data/repositories/physical_data_repository.dart';
import '../data/repositories/teacher_repositories/motification_teacher_repository.dart';
import '../data/repositories/teacher_repositories/my_classes_teacher_repository.dart';
import '../data/repositories/teacher_repositories/on_demand_teacher_repository.dart';

class Injector {
  Injector._();

  static final _dependency = GetIt.instance;

  static GetIt get dependency => _dependency;

  static void setup(
      {required AppConfig appConfig, required ProviderContainer container}) {
    _setUpUserLocalDataSource();
    _setupServiceConfig();
    _setupHttpClient();
    _setUpLoginDataRepository();
    _setUpLoginDataSource();
    _setUpHomeDataRepository();
    _setUpHomeDataSource();
    _setUpChronicDataRepository();
    _setUpChronicDataSource();
    _setUpPhysicalDataRepository();
    _setUpPhysicalDataSource();
    _setupGoogleSignIn();
    _setUpOnDemandStudentRepository();
    _setUpOnDemandStudentDataSource();
    _setUpOnDemandTeacherRepository();
    _setUpOnDemandTeacherDataSource();
    _setUpGuideStudentRepository();
    _setUpGuideStudentDataSource();
    _setUpDualLoginDataRepository();
    _setUpDualLoginDataSource();
    _setUpTeacherHomeDataRepository();
    _setUpTeacherHomeDataSource();
    _setFirebaseMessagingDataRepository();
    _setUpFirebaseMessagingDataSource();
    _setUpMyClassesStudentRepository();
    _setUpMYClassesStudentDataSource();
    _setUpMyClassesTeacherRepository();
    _setUpMYClassesTeacherDataSource();
    _setUpStudentAccountRepository();
    _setUpStudentAccountDataSource();
    _setUpTeacherAccountRepository();
    _setUpTeacherAccountDataSource();
    _setUpHelpSupportRepository();
    _setUpHelpSupportDataSource();
    _setUpSwitchRepository();
    _setUpSwitchDataSource();
    _setUpPaymentRepository();
    _setUpPaymentDataSource();
    _setUpNotificationStudentRepository();
    _setUpNotificationStudentDataSource();
    _setUpNotificationTeacherRepository();
    _setUpNotificationTeacherDataSource();
    _setUpMyTeachersTabDataSource();
    _setUpMyTeachersTabRepository();
    _setUpEarningsTeacherDataSource();
    _setUpEarningsTeacherDataRepository();

  }

  ///Create DataSource Methods here

  static void _setUpUserLocalDataSource() {
    _dependency.registerFactory<UserLocalDataSource>(() =>
        UserLocalDataSourceImpl(
            preferencesManager: SecurePreferencesManager()));
  }

  static void _setUpLoginDataSource() {
    _dependency.registerFactory<LoginDataSource>(
      LoginDataSourceImpl.new,
    );
  }

  static void _setUpHomeDataSource() {
    _dependency.registerFactory<HomeDataSource>(
      HomeDataSourceImpl.new,
    );
  }

  static void _setUpTeacherHomeDataSource() {
    _dependency.registerFactory<TeacherHomeDataSource>(
      TeacherHomeDataSourceImpl.new,
    );
  }

  static void _setUpMyTeachersTabDataSource() {
    _dependency.registerFactory<MyTeachersDataSource>(
      MyTeachersDataSourceImpl.new,
    );
  }

  static void _setUpEarningsTeacherDataSource() {
    _dependency.registerFactory<EarningsTeacherDataSource>(
      EarningsTeacherDataSourceImpl.new,
    );
  }

  static void _setUpChronicDataSource() {
    _dependency.registerFactory<ChronicDataSource>(
      ChronicDataSourceImpl.new,
    );
  }

  static void _setUpPhysicalDataSource() {
    _dependency.registerFactory<PhysicalDataSource>(
      PhysicalDataSourceImpl.new,
    );
  }

  static void _setUpDualLoginDataRepository() {
    _dependency.registerFactory<DualLoginRepository>(
          () =>
          DualLoginRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpHelpSupportRepository() {
    _dependency.registerFactory<HelpSupportRepository>(
          () =>
          HelpSupportRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpDualLoginDataSource() {
    _dependency.registerFactory<DualLoginDataSource>(
      DualLoginDataSourceImpl.new,
    );
  }

  static void _setUpOnDemandStudentDataSource() {
    _dependency.registerFactory<OnDemandStudentDataSource>(
      OnDemandStudentDataSourceImpl.new,
    );
  }

  static void _setUpOnDemandTeacherDataSource() {
    _dependency.registerFactory<OnDemandTeacherDataSource>(
      OnDemandTeacherDataSourceImpl.new,
    );
  }


  static void _setUpGuideStudentDataSource() {
    _dependency.registerFactory<GuideDataSource>(
      GuideDataSourceImpl.new,
    );
  }

  static void _setUpMYClassesStudentDataSource() {
    _dependency.registerFactory<MyClassesStudentDataSource>(
      MyClassesStudentDataSourceImpl.new,
    );
  }

  static void _setUpMYClassesTeacherDataSource() {
    _dependency.registerFactory<MyClassesTeacherDataSource>(
      MyClassesTeacherDataSourceImpl.new,
    );
  }

  static void _setUpStudentAccountDataSource() {
    _dependency.registerFactory<StudentAccountDataSource>(
      StudentAccountDataSourceImp.new,
    );
  }

  static void _setUpTeacherAccountDataSource() {
    _dependency.registerFactory<TeacherAccountDataSource>(
      TeacherAccountDataSourceImp.new,
    );
  }

  static void _setUpFirebaseMessagingDataSource() {
    _dependency.registerFactory<FirebaseMessagingDataSource>(
      FirebaseMessagingDataSourceImpl.new,
    );
  }

  static void _setUpHelpSupportDataSource() {
    _dependency.registerFactory<HelpSupportDataSource>(
      HelpSupportDataSourceImpl.new,
    );
  }

/*  static void _setUpStudentProfileDataSource() {
    _dependency.registerFactory<StudentDetailProfileDataSource>(
      StudentDetailProfileDataSourceImpl.new,
    );
  }*/

  ///Create Data-Repositories Methods here

  static void _setUpLoginDataRepository() {
    _dependency.registerFactory<LoginRepository>(
          () =>
          LoginRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpHomeDataRepository() {
    _dependency.registerFactory<HomeRepository>(
          () =>
          HomeRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpTeacherHomeDataRepository() {
    _dependency.registerFactory<TeacherHomeRepository>(
          () =>
          TeacherHomeRepositoryImpl(
            _dependency(),
          ),
    );
  }


  static void _setUpEarningsTeacherDataRepository() {
    _dependency.registerFactory<EarningsTeacherRepository>(
          () =>
              EarningsTeacherRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpChronicDataRepository() {
    _dependency.registerFactory<ChronicRepository>(
          () =>
          ChronicRepositoryImpl(
            _dependency<ChronicDataSource>(),
          ),
    );
  }

  static void _setUpPhysicalDataRepository() {
    _dependency.registerFactory<PhysicalRepository>(
          () =>
          PhysicalRepositoryImpl(
            _dependency<PhysicalDataSource>(),
          ),
    );
  }

  static void _setUpOnDemandStudentRepository() {
    _dependency.registerFactory<OnDemandStudentRepository>(
          () =>
          OnDemandStudentRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpOnDemandTeacherRepository() {
    _dependency.registerFactory<OnDemandTeacherRepository>(
          () =>
          OnDemandTeacherRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpMyTeachersTabRepository() {
    _dependency.registerFactory<MyTeachersRepository>(
          () =>
          MyTeachersRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpGuideStudentRepository() {
    _dependency.registerFactory<GuideRepository>(
          () =>
          GuideRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpMyClassesStudentRepository() {
    _dependency.registerFactory<MyClassesStudentRepository>(
          () =>
          MyClassesStudentRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpMyClassesTeacherRepository() {
    _dependency.registerFactory<MyClassesTeacherRepository>(
          () =>
          MyClassesTeacherRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setFirebaseMessagingDataRepository() {
    _dependency.registerFactory<FirebaseMessagingRepository>(
          () =>
          FirebaseMessagingRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpStudentAccountRepository() {
    _dependency.registerFactory<StudentAccountRepository>(
          () =>
          StudentAccountRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpTeacherAccountRepository() {
    _dependency.registerFactory<TeacherAccountRepository>(
          () =>
          TeacherAccountRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpSwitchRepository() {
    _dependency.registerFactory<SwitchScreenRepository>(
          () =>
          SwitchScreenRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpSwitchDataSource() {
    _dependency.registerFactory<SwithcScreenDataSource>(
      SwithcScreenDataSourceImpl.new,
    );
  }

  static void _setUpPaymentRepository() {
    _dependency.registerFactory<PaymentDataRepository>(
          () =>
          PaymentDataRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpPaymentDataSource() {
    _dependency.registerFactory<PaymentDataSource>(
      PaymentDataSourceImpl.new,
    );
  }

  static void _setUpNotificationStudentRepository() {
    _dependency.registerFactory<NotificationStudentRepository>(
          () =>
          NotificationStudentRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpNotificationStudentDataSource() {
    _dependency.registerFactory<NotificationStudentDataSource>(
      NotificationStudentDataSourceImpl.new,
    );
  }

  static void _setUpNotificationTeacherRepository() {
    _dependency.registerFactory<NotificationTeacherRepository>(
          () =>
          NotificationTeacherRepositoryImpl(
            _dependency(),
          ),
    );
  }

  static void _setUpNotificationTeacherDataSource() {
    _dependency.registerFactory<NotificationTeacherDataSource>(
      NotificationTeacherDataSourceImpl.new,
    );
  }

  ///Create External-Methods here

  static void _setupHttpClient() {
    _dependency.registerFactory<ApiService>(() {
      final dio = Dio(
          BaseOptions(receiveTimeout: 5 * 1000, connectTimeout: 10 * 1000));
      final serviceConfig = _dependency<ServiceConfig>();
      dio.interceptors.addAll(serviceConfig.getInterceptors());


      // if (kIsWeb) {
      // dio.httpClientAdapter = BrowserHttpClientAdapter();
      // return ApiService(dio: dio);
      // } else
      if (!kIsWeb && Platform.isIOS || Platform.isAndroid) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        return ApiService(dio: dio);
      } else {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        return ApiService(dio: dio);
      }
    });
  }

  static void _setupGoogleSignIn() {
    _dependency.registerFactory<GoogleSignInApi>(() => GoogleSignInApi());
  }

  // static void _setupHttpClient() {
  //   _dependency.registerFactory<ApiService>(() {
  //     final dio = Dio();
  //     final serviceConfig = _dependency<ServiceConfig>();
  //     dio.interceptors.addAll(serviceConfig.getInterceptors());
  //     // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate(HttpClient()).ba;
  //     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //         (HttpClient client) {
  //           client.badCertificateCallback =
  //               (X509Certificate cert, String host, int port) => true;
  //         };
  //     // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate(HttpClient client){
  //     //   client
  //     // }
  //     return ApiService(dio: dio);
  //   });
  // }

  static void _setupServiceConfig() {
    _dependency.registerFactory<ServiceConfig>(
          () => ServiceConfig(),
    );
  }
}
