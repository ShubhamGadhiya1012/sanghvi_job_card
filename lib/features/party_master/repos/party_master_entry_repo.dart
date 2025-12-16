import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class PartyMasterEntryRepo {
  static Future<List<PartyMasterDm>> getPartyList({
    required String search,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    final queryParams = {'SearchText': search};

    final response = await ApiService.getRequest(
      endpoint: '/Master/customer',
      token: token,
      queryParams: queryParams,
    );

    if (response == null || response['data'] == null) return [];

    return (response['data'] as List)
        .map((item) => PartyMasterDm.fromJson(item))
        .toList();
  }
}
