import 'package:get/get.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/features/party_master/repos/party_master_entry_repo.dart';

class PartyMasterEntryController extends GetxController {
  var isLoading = false.obs;
  var partyList = <PartyMasterDm>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getPartyList();
  }

  Future<void> getPartyList() async {
    isLoading.value = true;
    try {
      final fetchedList = await PartyMasterEntryRepo.getPartyList();
      partyList.assignAll(fetchedList);
    } finally {
      isLoading.value = false;
    }
  }
}
