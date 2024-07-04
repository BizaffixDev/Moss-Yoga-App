import 'package:moss_yoga/data/data_sources/physical_data_source.dart';

import '../models/physical_response_model.dart';

abstract class PhysicalRepository {
  Future<List<PhysicalResponseModel>> getPhyscialConditionList();
}


class PhysicalRepositoryImpl implements PhysicalRepository{

  final PhysicalDataSource physicalDataSource;

  PhysicalRepositoryImpl(this.physicalDataSource);


  @override
  Future<List<PhysicalResponseModel>> getPhyscialConditionList() {
    return physicalDataSource.getPhyscialConditionList();
  }

}