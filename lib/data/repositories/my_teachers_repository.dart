import 'package:moss_yoga/data/data_sources/my_teachers_data_source.dart';
import '../models/previous_teachers_model.dart';

abstract class MyTeachersRepository{

Future<List<PreviousTeachersResponseModel>> getPreviousTeachers({required String studentId});


}


class MyTeachersRepositoryImpl extends MyTeachersRepository {
  MyTeachersRepositoryImpl(this.myTeachersDataSource);

  final MyTeachersDataSource myTeachersDataSource;

  @override
  Future<List<PreviousTeachersResponseModel>> getPreviousTeachers({required String studentId}) {
   return myTeachersDataSource.getPreviousTeachers(studentId: studentId);
  }







}