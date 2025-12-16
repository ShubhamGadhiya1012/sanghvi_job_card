import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/features/party_master/repos/party_master_entry_repo.dart';

class PartyMasterEntryController extends GetxController {
  var isLoading = false.obs;
  var partyList = <PartyMasterDm>[].obs;
  final searchController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getPartyList();
  }

  Future<void> getPartyList() async {
    isLoading.value = true;
    try {
      final fetchedList = await PartyMasterEntryRepo.getPartyList(
        search: searchController.text,
      );
      partyList.assignAll(fetchedList);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPartyList() async {
    await getPartyList();
  }
}
