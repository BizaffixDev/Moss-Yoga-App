import 'package:moss_yoga/data/models/my_class_teacher_request_model.dart';
import 'package:moss_yoga/data/models/my_classes_teacher_response_model.dart';

import '../../data_sources/teacher_data_sources/my_classes_teacher_data_sources.dart';

abstract class MyClassesTeacherRepository{


  Future<MyClassesTeacherResponse> myClassesData({required MyClassTeacherRequest myClassTeacherRequest});
  Future<String> cancelBooking({required String bookingCode});
}


class MyClassesTeacherRepositoryImpl extends MyClassesTeacherRepository {
  MyClassesTeacherRepositoryImpl(this.myClassesTeacherDataSource);

  final MyClassesTeacherDataSource myClassesTeacherDataSource;


  @override
  Future<MyClassesTeacherResponse> myClassesData({required MyClassTeacherRequest myClassTeacherRequest}) {
    return myClassesTeacherDataSource.myClassesData(myClassTeacherRequest: myClassTeacherRequest);
  }

  @override
  Future<String> cancelBooking({required String bookingCode}) {
    return myClassesTeacherDataSource.cancelBooking(bookingCode: bookingCode);
  }


}