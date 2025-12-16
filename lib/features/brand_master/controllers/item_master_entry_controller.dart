import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/repos/item_master_entry_repo.dart';

class ItemMasterEntryController extends GetxController {
  var isLoading = false.obs;
  var itemList = <ItemMasterDm>[].obs;
  final searchController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getItemList();
  }

  Future<void> getItemList() async {
    isLoading.value = true;
    try {
      final fetchedList = await ItemMasterEntryRepo.getItemList(
        search: searchController.text,
      );
      itemList.assignAll(fetchedList);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshItemList() async {
    await getItemList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
