
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class HomeRepo {
  static Future<dynamic> checkVersion({
    required String version,
    required String deviceId,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/version',
        token: token,
        queryParams: {'Version': version, 'DeviceID': deviceId},
      );

      if (response == null) return [];

      if (response is List) return response;

      if (response is Map<String, dynamic> && response.containsKey('error')) {
        throw response['error'];
      }

      return [];
    } catch (e) {
      throw e.toString();
    }
  }
}
