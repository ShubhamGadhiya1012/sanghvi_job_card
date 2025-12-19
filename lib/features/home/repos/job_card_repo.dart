import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sanghvi_job_card/features/home/models/checked_dm.dart';
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

      // **CHANGE: Add ExistingAttachments as comma-separated string**
      if (existingAttachments.isNotEmpty) {
        fields['ExistingAttachments'] = existingAttachments.join(',');
      }

      final List<http.MultipartFile> multipartFiles = [];

      print('================ JOB CARD API PAYLOAD ================');

      // **REMOVED: Old code that sent existing attachments as multipart files**

      // ===== NEW FILE ATTACHMENTS =====
      for (var file in newFiles) {
        if (file.path != null) {
          multipartFiles.add(
            await http.MultipartFile.fromPath(
              'Attachments',
              file.path!,
              filename: file.name,
            ),
          );
          print('Attachments (new file): ${file.name}');
        } else if (file.bytes != null) {
          multipartFiles.add(
            http.MultipartFile.fromBytes(
              'Attachments',
              file.bytes!,
              filename: file.name,
            ),
          );
          print('Attachments (new file): ${file.name}');
        }
      }

      fields.forEach((key, value) {
        if (value.isNotEmpty) {
          print('$key: $value');
        }
      });
      print('Total new file attachments: ${multipartFiles.length}');
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
