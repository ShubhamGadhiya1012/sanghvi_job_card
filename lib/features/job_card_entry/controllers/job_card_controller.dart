import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/repos/item_master_entry_repo.dart';
import 'package:sanghvi_job_card/features/home/controllers/home_controller.dart';
import 'package:sanghvi_job_card/features/job_card_entry/models/checked_dm.dart';
import 'package:sanghvi_job_card/features/job_card_entry/models/job_card_dm.dart';
import 'package:sanghvi_job_card/features/job_card_entry/repos/job_card_repo.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/utils/dialogs/app_dialogs.dart';
import 'package:sanghvi_job_card/utils/helpers/date_format_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class JobCardController extends GetxController {
  var formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var isEditMode = false.obs;

  var dateController = TextEditingController();
  var poNoController = TextEditingController();
  var poDateController = TextEditingController();
  var orderQtyController = TextEditingController();
  var productionQtyController = TextEditingController();
  var extraInnerBoxController = TextEditingController();
  var extraOuterBoxController = TextEditingController();
  var extraTapeNosController = TextEditingController();
  var extraOuterController = TextEditingController();
  var remarkController = TextEditingController();
  var extraPrintedReelController = TextEditingController();
  var nos10PackingController = TextEditingController();

  // Auto-filled fields from Item Master (read-only)
  var tapeDimensionController = TextEditingController();
  var weightPer10NosController = TextEditingController();
  var reelColourController = TextEditingController();
  var reelTypeController = TextEditingController();
  var outerColourController = TextEditingController();
  var mrpController = TextEditingController();
  var reelPrintColourController = TextEditingController();
  var outerPrintColourController = TextEditingController();
  var packing10NosController = TextEditingController();
  var innerBoxLabelController = TextEditingController();
  var innerBoxQtyController = TextEditingController();
  var innerBoxColourController = TextEditingController();
  var masterBoxTypeController = TextEditingController();
  var masterBoxColourController = TextEditingController();
  var masterBoxLabelController = TextEditingController();

  var partyList = <PartyMasterDm>[].obs;
  var partyNames = <String>[].obs;
  var selectedParty = Rx<PartyMasterDm?>(null);

  var itemList = <ItemMasterDm>[].obs;
  var itemNames = <String>[].obs;
  var selectedItem = Rx<ItemMasterDm?>(null);

  var checkedList = <CheckedDm>[].obs;
  var checkedNames = <String>[].obs;
  var selectedChecked1 = ''.obs;
  var selectedChecked2 = ''.obs;

  var currentInvno = ''.obs;
  var attachmentFiles = <PlatformFile>[].obs;
  var existingAttachmentUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    poDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  Future<void> fetchDropdownData() async {
    isLoading.value = true;
    await getParties();
    await getItems();
    await getCheckedList();
    isLoading.value = false;
  }

  Future<void> getParties() async {
    try {
      final data = await JobCardRepo.getParties();
      partyList.assignAll(data);
      partyNames.assignAll(data.map((e) => e.pName));
    } catch (_) {}
  }

  void onPartySelected(String? partyName) {
    if (partyName != null && partyName.isNotEmpty) {
      final selected = partyList.firstWhere(
        (p) => p.pName == partyName,
        orElse: () => partyList.first,
      );
      selectedParty.value = selected;
    }
  }

  Future<void> getItems() async {
    try {
      final data = await ItemMasterEntryRepo.getItemList(search: '');
      itemList.assignAll(data);
      itemNames.assignAll(data.map((e) => e.iName));
    } catch (_) {}
  }

  void onItemSelected(String? itemName) {
    if (itemName != null && itemName.isNotEmpty) {
      final selected = itemList.firstWhere(
        (i) => i.iName == itemName,
        orElse: () => itemList.first,
      );
      selectedItem.value = selected;

      // Auto-fill item master fields
      tapeDimensionController.text = selected.description;
      weightPer10NosController.text = selected.weightPer10Nos;
      reelColourController.text = selected.reelColour;
      reelTypeController.text = selected.reelType;
      outerColourController.text = selected.outerColour;
      mrpController.text = selected.mrp;
      reelPrintColourController.text = selected.reelPrintColour;
      outerPrintColourController.text = selected.outerPrintColour;
      packing10NosController.text = selected.nos10Packing;
      innerBoxLabelController.text = selected.innerBoxLabel;
      innerBoxQtyController.text = selected.innerBoxQty;
      innerBoxColourController.text = selected.innerBoxColour;
      masterBoxTypeController.text = selected.masterBoxType;
      masterBoxColourController.text = selected.masterBoxColour;
      masterBoxLabelController.text = selected.masterBoxLabel;
    }
  }

  Future<void> getCheckedList() async {
    try {
      final data = await JobCardRepo.getCheckedList();
      checkedList.assignAll(data);
      checkedNames.assignAll(data.map((e) => e.value));
    } catch (_) {}
  }

  void onChecked1Selected(String? value) {
    selectedChecked1.value = value ?? '';
  }

  void onChecked2Selected(String? value) {
    selectedChecked2.value = value ?? '';
  }

  void autoFillDataForEdit(JobCardDm jobCard) async {
    isEditMode.value = true;
    currentInvno.value = jobCard.invno;

    dateController.text = convertyyyyMMddToddMMyyyy(jobCard.date);
    poNoController.text = jobCard.poNo;
    poDateController.text = convertyyyyMMddToddMMyyyy(jobCard.poDate);
    orderQtyController.text = jobCard.orderQty;
    productionQtyController.text = jobCard.productionQty;
    extraInnerBoxController.text = jobCard.extraInnerBox;
    extraOuterBoxController.text = jobCard.extraOuterBox;
    extraTapeNosController.text = jobCard.extraTapeNos;
    extraOuterController.text = jobCard.extraOuter;
    remarkController.text = jobCard.remark;
    extraPrintedReelController.text = jobCard.extraPrintedReel;
    nos10PackingController.text = jobCard.nos10Packing;

    if (partyList.isEmpty || itemList.isEmpty || checkedList.isEmpty) {
      await fetchDropdownData();
    }

    if (jobCard.pCode.isNotEmpty && partyList.isNotEmpty) {
      try {
        final party = partyList.firstWhere(
          (p) => p.pCode == jobCard.pCode,
          orElse: () => throw Exception('Party not found'),
        );
        selectedParty.value = party;
      } catch (e) {
        selectedParty.value = null;
      }
    }

    if (jobCard.iCode.isNotEmpty && itemList.isNotEmpty) {
      try {
        final item = itemList.firstWhere(
          (i) => i.iCode == jobCard.iCode,
          orElse: () => throw Exception('Item not found'),
        );
        selectedItem.value = item;

        // ADD THIS: Auto-fill item master fields when editing
        tapeDimensionController.text = item.description;
        weightPer10NosController.text = item.weightPer10Nos;
        reelColourController.text = item.reelColour;
        reelTypeController.text = item.reelType;
        outerColourController.text = item.outerColour;
        mrpController.text = item.mrp;
        reelPrintColourController.text = item.reelPrintColour;
        outerPrintColourController.text = item.outerPrintColour;
        packing10NosController.text = item.nos10Packing;
        innerBoxLabelController.text = item.innerBoxLabel;
        innerBoxQtyController.text = item.innerBoxQty;
        innerBoxColourController.text = item.innerBoxColour;
        masterBoxTypeController.text = item.masterBoxType;
        masterBoxColourController.text = item.masterBoxColour;
        masterBoxLabelController.text = item.masterBoxLabel;
      } catch (e) {
        selectedItem.value = null;
      }
    }

    if (jobCard.checked1.isNotEmpty) {
      selectedChecked1.value = jobCard.checked1;
    }

    if (jobCard.checked2.isNotEmpty) {
      selectedChecked2.value = jobCard.checked2;
    }

    if (jobCard.attachments.isNotEmpty) {
      existingAttachmentUrls.clear();
      existingAttachmentUrls.addAll(jobCard.attachments.split(','));
    }
  }

  Future<void> pickFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        final File file = File(photo.path);
        final bytes = await file.readAsBytes();

        final platformFile = PlatformFile(
          name: photo.name,
          size: bytes.length,
          path: photo.path,
          bytes: bytes,
        );

        attachmentFiles.add(platformFile);
      }
    } catch (e) {
      showErrorSnackbar('Error', 'Failed to capture image: ${e.toString()}');
    }
  }

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'jpg',
          'jpeg',
          'png',
          'gif',
          'xls',
          'xlsx',
        ],
      );

      if (result != null) {
        attachmentFiles.addAll(result.files);
      }
    } catch (e) {
      showErrorSnackbar('Error', 'Failed to pick files: ${e.toString()}');
    }
  }

  void removeFile(int index) {
    attachmentFiles.removeAt(index);
  }

  void removeExistingAttachment(int index) {
    existingAttachmentUrls.removeAt(index);
  }

  Future<void> openAttachment(String fileUrl) async {
    String url =
        'http://192.168.0.145:8080/JobCard/${fileUrl.replaceAll('\\', '/')}';

    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
          showErrorSnackbar('Error', 'Could not open attachment');
        }
      }
    } catch (e) {
      showErrorSnackbar('Error', 'Failed to open attachment: ${e.toString()}');
    }
  }

  final HomeController homeController = Get.find<HomeController>();

  Future<void> saveJobCard() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedParty.value == null) {
      showErrorSnackbar('Error', 'Please select a party');
      return;
    }

    if (selectedItem.value == null) {
      showErrorSnackbar('Error', 'Please select an item');
      return;
    }

    isLoading.value = true;

    try {
      var response = await JobCardRepo.saveJobCard(
        invno: isEditMode.value ? currentInvno.value : '',
        date: convertToApiDateFormat(dateController.text),
        pCode: selectedParty.value?.pCode ?? '',
        poNo: poNoController.text,
        poDate: convertToApiDateFormat(poDateController.text),
        iCode: selectedItem.value?.iCode ?? '',
        orderQty: orderQtyController.text,
        productionQty: productionQtyController.text,
        extraInnerBox: extraInnerBoxController.text,
        extraOuterBox: extraOuterBoxController.text,
        extraTapeNos: extraTapeNosController.text,
        extraOuter: extraOuterController.text,
        remark: remarkController.text,
        checked1: selectedChecked1.value,
        checked2: selectedChecked2.value,
        extraPrintedReel: extraPrintedReelController.text,
        nos10Packing: nos10PackingController.text,
        newFiles: attachmentFiles.toList(),
        existingAttachments: existingAttachmentUrls.toList(),
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.back();
        showSuccessSnackbar('Success', message);
        homeController.refreshJobCards();
        clearAll();
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar('Error', e['message']);
      } else {
        showErrorSnackbar('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }


  void clearAll() {
    currentInvno.value = '';
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    poNoController.clear();
    poDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    orderQtyController.clear();
    productionQtyController.clear();
    extraInnerBoxController.clear();
    extraOuterBoxController.clear();
    extraTapeNosController.clear();
    extraOuterController.clear();
    remarkController.clear();
    extraPrintedReelController.clear();
    nos10PackingController.clear();

    selectedParty.value = null;
    selectedItem.value = null;
    selectedChecked1.value = '';
    selectedChecked2.value = '';

    attachmentFiles.clear();
    existingAttachmentUrls.clear();

    tapeDimensionController.clear();
    weightPer10NosController.clear();
    reelColourController.clear();
    reelTypeController.clear();
    outerColourController.clear();
    mrpController.clear();
    reelPrintColourController.clear();
    outerPrintColourController.clear();
    packing10NosController.clear();
    innerBoxLabelController.clear();
    innerBoxQtyController.clear();
    innerBoxColourController.clear();
    masterBoxTypeController.clear();
    masterBoxColourController.clear();
    masterBoxLabelController.clear();

    isEditMode.value = false;
  }
}
