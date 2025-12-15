import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class PartyMasterEntryRepo {
  static Future<List<PartyMasterDm>> getPartyList() async {
    String? token = await SecureStorageHelper.read('token');

    final response = await ApiService.getRequest(
      endpoint: '/Master/customer',
      token: token,
    );

    if (response == null || response['data'] == null) return [];

    return (response['data'] as List)
        .map((item) => PartyMasterDm.fromJson(item))
        .toList();
  }
}
