import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/features/brand_master/controllers/item_master_entry_controller.dart';
import 'package:sanghvi_job_card/features/brand_master/models/color_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/inner_box_label_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/master_box_label_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/nos_packing_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/models/reel_type_dm.dart';
import 'package:sanghvi_job_card/features/brand_master/repos/item_master_repo.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/utils/dialogs/app_dialogs.dart';

class ItemMasterController extends GetxController {
  var formKey = GlobalKey<FormState>();

  var iNameController = TextEditingController();
  var tapeDimensionController = TextEditingController();
  var mrpController = TextEditingController();
  var weightPer10KgController = TextEditingController();
  var innerBoxQtyController = TextEditingController();
  var masterBoxTypeController = TextEditingController();
  var extraPrintedReelKgController = TextEditingController();
  var extraInnerBoxController = TextEditingController();
  var extraOuterBoxController = TextEditingController();
  var extraTapeNosController = TextEditingController();
  var extraOuterController = TextEditingController();

  var partyList = <PartyMasterDm>[].obs;
  var partyNames = <String>[].obs;
  var selectedParty = Rx<PartyMasterDm?>(null);

  var colorList = <ColorDm>[].obs;
  var colorNames = <String>[].obs;
  var selectedReelColour = ''.obs;
  var selectedOuterColour = ''.obs;
  var selectedReelPrintColour = ''.obs;
  var selectedOuterPrintColour = ''.obs;
  var selectedInnerBoxColour = ''.obs;
  var selectedMasterBoxColour = ''.obs;

  var reelTypeList = <ReelTypeDm>[].obs;
  var reelTypeNames = <String>[].obs;
  var selectedReelType = ''.obs;

  var innerBoxLabelList = <InnerBoxLabelDm>[].obs;
  var innerBoxLabelNames = <String>[].obs;
  var selectedInnerBoxLabel = ''.obs;

  var masterBoxLabelList = <MasterBoxLabelDm>[].obs;
  var masterBoxLabelNames = <String>[].obs;
  var selectedMasterBoxLabel = ''.obs;

  var nosPackingList = <NosPackingDm>[].obs;
  var nosPackingNames = <String>[].obs;
  var selectedPacking10Nos = ''.obs;

  var isLoading = false.obs;
  var isEditMode = false.obs;
  var currentICode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
  }

  void autoFillDataForEdit(ItemMasterDm item) async {
    isEditMode.value = true;
    currentICode.value = item.iCode;

    iNameController.text = item.iName;
    tapeDimensionController.text = item.description;
    mrpController.text = item.mrp;
    weightPer10KgController.text = item.weightPer10Nos;
    innerBoxQtyController.text = item.innerBoxQty;
    masterBoxTypeController.text = item.masterBoxType;

    if (partyList.isEmpty) {
      await fetchDropdownData();
    }

    if (item.pCode.isNotEmpty && partyList.isNotEmpty) {
      try {
        final party = partyList.firstWhere(
          (p) => p.pCode == item.pCode,
          orElse: () => throw Exception('Party not found'),
        );
        selectedParty.value = party;
      } catch (e) {
        selectedParty.value = null;
      }
    }

    if (item.reelColour.isNotEmpty) {
      selectedReelColour.value = item.reelColour;
    }

    if (item.reelType.isNotEmpty) {
      selectedReelType.value = item.reelType;
    }

    if (item.outerColour.isNotEmpty) {
      selectedOuterColour.value = item.outerColour;
    }

    if (item.reelPrintColour.isNotEmpty) {
      selectedReelPrintColour.value = item.reelPrintColour;
    }

    if (item.outerPrintColour.isNotEmpty) {
      selectedOuterPrintColour.value = item.outerPrintColour;
    }

    if (item.nos10Packing.isNotEmpty) {
      selectedPacking10Nos.value = item.nos10Packing;
    }

    if (item.innerBoxLabel.isNotEmpty) {
      selectedInnerBoxLabel.value = item.innerBoxLabel;
    }

    if (item.innerBoxColour.isNotEmpty) {
      selectedInnerBoxColour.value = item.innerBoxColour;
    }

    if (item.masterBoxColour.isNotEmpty) {
      selectedMasterBoxColour.value = item.masterBoxColour;
    }

    if (item.masterBoxLabel.isNotEmpty) {
      selectedMasterBoxLabel.value = item.masterBoxLabel;
    }
  }

  Future<void> fetchDropdownData() async {
    isLoading.value = true;
    await getPartyList();
    await getColors();
    await getReelTypes();
    await getInnerBoxLabels();
    await getMasterBoxLabels();
    await getNosPackings();
    isLoading.value = false;
  }

  Future<void> getPartyList() async {
    isLoading.value = true;
    try {
      final data = await ItemMasterRepo.getPartyList();
      partyList.assignAll(data);
      partyNames.assignAll(data.map((e) => e.pName));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
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

  Future<void> getColors() async {
    isLoading.value = true;
    try {
      final data = await ItemMasterRepo.getColors();
      colorList.assignAll(data);
      colorNames.assignAll(data.map((e) => e.value));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void onReelColourSelected(String? colour) {
    selectedReelColour.value = colour ?? '';
  }

  void onOuterColourSelected(String? colour) {
    selectedOuterColour.value = colour ?? '';
  }

  void onReelPrintColourSelected(String? colour) {
    selectedReelPrintColour.value = colour ?? '';
  }

  void onOuterPrintColourSelected(String? colour) {
    selectedOuterPrintColour.value = colour ?? '';
  }

  void onInnerBoxColourSelected(String? colour) {
    selectedInnerBoxColour.value = colour ?? '';
  }

  void onMasterBoxColourSelected(String? colour) {
    selectedMasterBoxColour.value = colour ?? '';
  }

  Future<void> getReelTypes() async {
    isLoading.value = true;
    try {
      final data = await ItemMasterRepo.getReelTypes();
      reelTypeList.assignAll(data);
      reelTypeNames.assignAll(data.map((e) => e.value));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void onReelTypeSelected(String? type) {
    selectedReelType.value = type ?? '';
  }

  Future<void> getInnerBoxLabels() async {
    isLoading.value = true;
    try {
      final data = await ItemMasterRepo.getInnerBoxLabels();
      innerBoxLabelList.assignAll(data);
      innerBoxLabelNames.assignAll(data.map((e) => e.value));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void onInnerBoxLabelSelected(String? label) {
    selectedInnerBoxLabel.value = label ?? '';
  }

  Future<void> getMasterBoxLabels() async {
    isLoading.value = true;
    try {
      final data = await ItemMasterRepo.getMasterBoxLabels();
      masterBoxLabelList.assignAll(data);
      masterBoxLabelNames.assignAll(data.map((e) => e.value));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void onMasterBoxLabelSelected(String? label) {
    selectedMasterBoxLabel.value = label ?? '';
  }

  Future<void> getNosPackings() async {
    isLoading.value = true;
    try {
      final data = await ItemMasterRepo.getNosPackings();
      nosPackingList.assignAll(data);
      nosPackingNames.assignAll(data.map((e) => e.value));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void onPacking10NosSelected(String? packing) {
    selectedPacking10Nos.value = packing ?? '';
  }

  final ItemMasterEntryController itemMasterEntryController =
      Get.find<ItemMasterEntryController>();

  Future<void> saveItemMaster() async {
    isLoading.value = true;
    try {
      var response = await ItemMasterRepo.saveItemMaster(
        iCode: isEditMode.value ? currentICode.value : '',
        iName: iNameController.text,
        tapeDimension: tapeDimensionController.text,
        pCode: selectedParty.value?.pCode ?? '',
        mrp: mrpController.text,
        weightPer10Kg: weightPer10KgController.text,
        reelColour: selectedReelColour.value,
        reelType: selectedReelType.value,
        outerColour: selectedOuterColour.value,
        reelPrintColour: selectedReelPrintColour.value,
        outerPrintColour: selectedOuterPrintColour.value,
        packing10Nos: selectedPacking10Nos.value,
        innerBoxLabel: selectedInnerBoxLabel.value,
        innerBoxQty: innerBoxQtyController.text,
        innerBoxColour: selectedInnerBoxColour.value,
        masterBoxType: masterBoxTypeController.text,
        masterBoxColour: selectedMasterBoxColour.value,
        masterBoxLabel: selectedMasterBoxLabel.value,
        extraPrintedReelKg: extraPrintedReelKgController.text,
        extraInnerBox: extraInnerBoxController.text,
        extraOuterBox: extraOuterBoxController.text,
        extraTapeNos: extraTapeNosController.text,
        extraOuter: extraOuterController.text,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.back();
        showSuccessSnackbar('Success', message);
        itemMasterEntryController.getItemList();
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
    iNameController.clear();
    tapeDimensionController.clear();
    mrpController.clear();
    weightPer10KgController.clear();
    innerBoxQtyController.clear();
    masterBoxTypeController.clear();
    extraPrintedReelKgController.clear();
    extraInnerBoxController.clear();
    extraOuterBoxController.clear();
    extraTapeNosController.clear();
    extraOuterController.clear();

    selectedParty.value = null;
    selectedReelColour.value = '';
    selectedOuterColour.value = '';
    selectedReelPrintColour.value = '';
    selectedOuterPrintColour.value = '';
    selectedInnerBoxColour.value = '';
    selectedMasterBoxColour.value = '';
    selectedReelType.value = '';
    selectedInnerBoxLabel.value = '';
    selectedMasterBoxLabel.value = '';
    selectedPacking10Nos.value = '';

    isEditMode.value = false;
    currentICode.value = '';
  }
}
