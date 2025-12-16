import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sanghvi_job_card/features/job_card_entry/models/checked_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/services/api_service.dart';
import 'package:sanghvi_job_card/utils/helpers/secure_storage_helper.dart';

class JobCardRepo {
  static Future<List<PartyMasterDm>> getParties() async {
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

  static Future<List<CheckedDm>> getCheckedList() async {
    String? token = await SecureStorageHelper.read('token');
    final response = await ApiService.getRequest(
      endpoint: '/Master/getChecked',
      token: token,
    );
    if (response == null || response['data'] == null) return [];
    return (response['data'] as List)
        .map((e) => CheckedDm.fromJson(e))
        .toList();
  }

  static Future<dynamic> saveJobCard({
    required String invno,
    required String date,
    required String pCode,
    required String poNo,
    required String poDate,
    required String iCode,
    required String orderQty,
    required String productionQty,
    required String extraInnerBox,
    required String extraOuterBox,
    required String extraTapeNos,
    required String extraOuter,
    required String remark,
    required String checked1,
    required String checked2,
    required String extraPrintedReel,
    required String nos10Packing,
    required List<PlatformFile> newFiles,
    required List<String> existingAttachments,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final Map<String, String> fields = {
        'Invno': invno,
        'Date': date,
        'PCode': pCode,
        'PONo': poNo,
        'PODate': poDate,
        'ICode': iCode,
        'OrderQty': orderQty,
        'ProductionQty': productionQty,
        'ExtraInnerBox': extraInnerBox,
        'ExtraOuterBox': extraOuterBox,
        'ExtraTapeNos': extraTapeNos,
        'ExtraOuter': extraOuter,
        'Remark': remark,
        'Checked1': checked1,
        'Checked2': checked2,
        'ExtraPrintedReel': extraPrintedReel,
        'Nos10Packing': nos10Packing,
      };

      final List<http.MultipartFile> multipartFiles = [];

      for (var i = 0; i < existingAttachments.length; i++) {
        fields['ExistingAttachments[$i]'] = existingAttachments[i];
      }

      for (var file in newFiles) {
        if (file.path != null) {
          multipartFiles.add(
            await http.MultipartFile.fromPath(
              'Attachments',
              file.path!,
              filename: file.name,
            ),
          );
        } else if (file.bytes != null) {
          multipartFiles.add(
            http.MultipartFile.fromBytes(
              'Attachments',
              file.bytes!,
              filename: file.name,
            ),
          );
        }
      }

      print('================ JOB CARD API PAYLOAD ================');

      fields.forEach((key, value) {
        if (value.toString().isNotEmpty) {
          print('$key : $value');
        }
      });

      for (var file in multipartFiles) {
        print('${file.field} : ${file.filename}');
      }

      print('======================================================');
 
      final response = await ApiService.postFormData(
        endpoint: '/JobCard/addUpdateJobCard',
        fields: fields,
        files: multipartFiles,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
