import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPlatformProvider = StateProvider<CurrentPlatform>((_) {
  // return CurrentPlatform.initial;
  return CurrentPlatform.Student;
});

final sessionTimeoutProvider = StateProvider<bool>((_) {
  // return CurrentPlatform.initial;
  return true;
});

///Maybe gotta make this a notifier so its always listening
// final isLockedTeacherProvider = StateProvider<bool>((_) {
//   // return CurrentPlatform.initial;
//   return true;
// });
class LockedTeacherNotifier extends StateNotifier<bool> {
  LockedTeacherNotifier() : super(true);

  void setLockedStatus(bool isLocked) {
    state = isLocked;
  }
}

final isLockedTeacherProvider =
    StateNotifierProvider<LockedTeacherNotifier, bool>(
        (ref) => LockedTeacherNotifier());

// final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
//   return Injector.dependency<UserLocalDataSource>();
// });
// final sharedPreferencesUserObjectProvider =
//     FutureProvider<LoginResponseModel>((ref) async {
//   final userDataSource = ref.watch(userLocalDataSourceProvider);
//   final user = await userDataSource.getUser();
//   if (user != null) {
//     return user;
//   } else {
//     throw Exception("User not found");
//   }
// });

final bottomBarCurrentIndexProvider = StateProvider<int>((_) {
  return 0;
});

enum CurrentPlatform { Student, Teacher }
