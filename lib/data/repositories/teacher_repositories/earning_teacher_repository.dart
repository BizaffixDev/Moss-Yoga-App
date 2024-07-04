
import '../../data_sources/teacher_data_sources/earning_teacher_data_source.dart';
import '../../models/earnings_teacher_response_model.dart';



abstract class EarningsTeacherRepository{


  Future<EarningsTeacherResponse> getTotalEarningTeacher({required String teacherId});

}


class EarningsTeacherRepositoryImpl extends EarningsTeacherRepository {
  EarningsTeacherRepositoryImpl(this.earningsTeacherDataSource);

  final EarningsTeacherDataSource earningsTeacherDataSource;

  @override
  Future<EarningsTeacherResponse> getTotalEarningTeacher({required String teacherId}) {
   return earningsTeacherDataSource.getTotalEarningTeacher(teacherId: teacherId);
  }





}