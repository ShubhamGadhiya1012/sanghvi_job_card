import 'package:get/get.dart';
import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/repos/item_master_entry_repo.dart';

class ItemMasterEntryController extends GetxController {
  var isLoading = false.obs;
  var itemList = <ItemMasterDm>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getItemList();
  }

  Future<void> getItemList() async {
    isLoading.value = true;
    try {
      final fetchedList = await ItemMasterEntryRepo.getItemList();
      itemList.assignAll(fetchedList);
    } finally {
      isLoading.value = false;
    }
  }
}
