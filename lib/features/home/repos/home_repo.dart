import 'package:sanghvi_job_card/features/home/models/job_card_dm.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class HomeRepo {
  // Add these methods in HomeRepo class
  static Future<List<JobCardDm>> getJobCards({
    required String search,
    required int page,
    required int pageSize,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    final queryParams = {
      'SearchText': search,
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
    };

    final response = await ApiService.getRequest(
      endpoint: '/JobCard/getJobCard',
      token: token,
      queryParams: queryParams,
    );

    if (response == null || response['data'] == null) return [];

    return (response['data'] as List)
        .map((item) => JobCardDm.fromJson(item))
        .toList();
  }

  static Future<dynamic> deleteJobCard(String invno) async {
    String? token = await SecureStorageHelper.read('token');

    final queryParams = {'Invno': invno};

    try {
      final response = await ApiService.getRequest(
        endpoint: '/JobCard/deleteJobCard',
        token: token,
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

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
