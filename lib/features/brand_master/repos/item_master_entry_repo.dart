import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class ItemMasterEntryRepo {
  static Future<List<ItemMasterDm>> getItemList() async {
    String? token = await SecureStorageHelper.read('token');

    final response = await ApiService.getRequest(
      endpoint: '/Master/getitems',
      token: token,
    );

    if (response == null || response['data'] == null) return [];

    return (response['data'] as List)
        .map((item) => ItemMasterDm.fromJson(item))
        .toList();
  }
}
