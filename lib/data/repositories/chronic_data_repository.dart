import 'package:moss_yoga/data/data_sources/chronic_data_source.dart';
import 'package:moss_yoga/data/models/chronic_response_model.dart';


abstract class ChronicRepository {
  Future<List<ChronicResponseModel>>  getChronicConditionList();
}

class ChronicRepositoryImpl implements ChronicRepository{

   final ChronicDataSource chronicDataSource;

   ChronicRepositoryImpl(this.chronicDataSource);

  @override
  Future<List<ChronicResponseModel>> getChronicConditionList() {

   return chronicDataSource.getChronicConditionList();
  }

}