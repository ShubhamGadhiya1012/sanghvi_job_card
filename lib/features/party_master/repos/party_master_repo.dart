import 'package:sanghvi_job_card/features/party_master/models/city_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/location_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/state_dm.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class PartyMasterRepo {
  static Future<List<LocationDm>> getLocations() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getLocation',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List)
        .map((e) => LocationDm.fromJson(e))
        .toList();
  }

  static Future<List<CityDm>> getCities() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getCity',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List).map((e) => CityDm.fromJson(e)).toList();
  }

  static Future<List<StateDm>> getStates() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getState',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List).map((e) => StateDm.fromJson(e)).toList();
  }

  static Future<dynamic> savePartyMaster({
    required String pCode,
    required String accountName,
    required String printName,
    required String location,
    required String addressLine1,
    required String addressLine2,
    required String addressLine3,
    required String city,
    required String state,
    required String pinCode,
    required String personName,
    required String phone1,
    required String phone2,
    required String mobile,
    required String gstNumber,
    required String panNumber,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    final body = {
      'PCode': pCode,
      'AccountName': accountName,
      'PrintName': printName,
      'Location': location,
      'AddressLine1': addressLine1,
      'AddressLine2': addressLine2,
      'AddressLine3': addressLine3,
      'City': city,
      'State': state,
      'PinCode': pinCode,
      'PersonName': personName,
      'Phone1': phone1,
      'Phone2': phone2,
      'Mobile': mobile,
      'GSTNumber': gstNumber,
      'PANNumber': panNumber,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Master/addPartyMaster',
        requestBody: body,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
