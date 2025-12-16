import 'package:sanghvi_job_card/features/brand_master/models/color_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/inner_box_label_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/master_box_label_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/nos_packing_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/reel_type_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class ItemMasterRepo {
  static Future<List<PartyMasterDm>> getPartyList() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/customer',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List)
        .map((e) => PartyMasterDm.fromJson(e))
        .toList();
  }

  static Future<List<ColorDm>> getColors() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getColor',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List).map((e) => ColorDm.fromJson(e)).toList();
  }

  static Future<List<ReelTypeDm>> getReelTypes() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getReelType',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List)
        .map((e) => ReelTypeDm.fromJson(e))
        .toList();
  }

  static Future<List<InnerBoxLabelDm>> getInnerBoxLabels() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getInnerBoxLabel',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List)
        .map((e) => InnerBoxLabelDm.fromJson(e))
        .toList();
  }

  static Future<List<MasterBoxLabelDm>> getMasterBoxLabels() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getMasterBoxLabel',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List)
        .map((e) => MasterBoxLabelDm.fromJson(e))
        .toList();
  }

  static Future<List<NosPackingDm>> getNosPackings() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getNosPacking',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List)
        .map((e) => NosPackingDm.fromJson(e))
        .toList();
  }

  static Future<dynamic> saveItemMaster({
    required String iCode,
    required String iName,
    required String tapeDimension,
    required String pCode,
    required String mrp,
    required String weightPer10Kg,
    required String reelColour,
    required String reelType,
    required String outerColour,
    required String reelPrintColour,
    required String outerPrintColour,
    required String packing10Nos,
    required String innerBoxLabel,
    required String innerBoxQty,
    required String innerBoxColour,
    required String masterBoxType,
    required String masterBoxColour,
    required String masterBoxLabel,
    required String extraPrintedReelKg,
    required String extraInnerBox,
    required String extraOuterBox,
    required String extraTapeNos,
    required String extraOuter,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    final body = {
      'ICode': iCode,
      'IName': iName,
      'TapeDimension': tapeDimension,
      'PCode': pCode,
      'Mrp': mrp,
      'WeightPer10Kg': weightPer10Kg,
      'ReelColour': reelColour,
      'ReelType': reelType,
      'OuterColour': outerColour,
      'ReelPrintColour': reelPrintColour,
      'OuterPrintColour': outerPrintColour,
      'Packing10Nos': packing10Nos,
      'InnerBoxLabel': innerBoxLabel,
      'InnerBoxQty': innerBoxQty,
      'InnerBoxColour': innerBoxColour,
      'MasterBoxType': masterBoxType,
      'MasterBoxColour': masterBoxColour,
      'MasterBoxLabel': masterBoxLabel,
      'ExtraPrintedReelKg': extraPrintedReelKg,
      'ExtraInnerBox': extraInnerBox,
      'ExtraOuterBox': extraOuterBox,
      'ExtraTapeNos': extraTapeNos,
      'ExtraOuter': extraOuter,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Master/addItemMaster',
        requestBody: body,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
