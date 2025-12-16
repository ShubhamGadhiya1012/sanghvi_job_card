import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sanghvi_job_card/features/party_master/controllers/party_master_entry_controller.dart';
import 'package:sanghvi_job_card/features/party_master/models/city_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/location_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/party_master_dm.dart';
import 'package:sanghvi_job_card/features/party_master/models/state_dm.dart';
import 'package:sanghvi_job_card/features/party_master/repos/party_master_repo.dart';
import 'package:sanghvi_job_card/utils/dialogs/app_dialogs.dart';

class PartyMasterController extends GetxController {
  var formKey = GlobalKey<FormState>();

  var accountNameController = TextEditingController();
  var printNameController = TextEditingController();
  var addressLine1Controller = TextEditingController();
  var addressLine2Controller = TextEditingController();
  var addressLine3Controller = TextEditingController();
  var pinCodeController = TextEditingController();
  var personNameController = TextEditingController();
  var phone1Controller = TextEditingController();
  var phone2Controller = TextEditingController();
  var mobileController = TextEditingController();
  var gstNumberController = TextEditingController();
  var panNumberController = TextEditingController();

  var locationList = <LocationDm>[].obs;
  var locationNames = <String>[].obs;
  var selectedLocation = ''.obs;

  var cityList = <CityDm>[].obs;
  var cityNames = <String>[].obs;
  var selectedCity = ''.obs;

  var stateList = <StateDm>[].obs;
  var stateNames = <String>[].obs;
  var selectedState = ''.obs;

  var isLoading = false.obs;
  var isEditMode = false.obs;
  var currentPCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
  }

  void autoFillDataForEdit(PartyMasterDm party) async {
    isEditMode.value = true;
    currentPCode.value = party.pCode;

    accountNameController.text = party.pName;
    printNameController.text = party.printName;
    addressLine1Controller.text = party.address1;
    addressLine2Controller.text = party.address2;
    addressLine3Controller.text = party.address3;
    pinCodeController.text = party.pinCode;
    personNameController.text = party.peronName;
    phone1Controller.text = party.phone1;
    phone2Controller.text = party.phone2;
    mobileController.text = party.mobile;
    gstNumberController.text = party.gstNumber;
    panNumberController.text = party.panNumber;

    if (party.location.isNotEmpty) {
      selectedLocation.value = party.location;
    }

    if (party.city.isNotEmpty) {
      selectedCity.value = party.city;
    }

    if (party.state.isNotEmpty) {
      selectedState.value = party.state;
    }
  }

  Future<void> fetchDropdownData() async {
    isLoading.value = true;
    await getLocations();
    await getCities();
    await getStates();
    isLoading.value = false;
  }

  Future<void> getLocations() async {
    try {
      final data = await PartyMasterRepo.getLocations();
      locationList.assignAll(data);
      locationNames.assignAll(data.map((e) => e.value));
    } catch (_) {}
  }

  void onLocationSelected(String? location) {
    selectedLocation.value = location ?? '';
  }

  Future<void> getCities() async {
    try {
      final data = await PartyMasterRepo.getCities();
      cityList.assignAll(data);
      cityNames.assignAll(data.map((e) => e.value));
    } catch (_) {}
  }

  void onCitySelected(String? city) {
    selectedCity.value = city ?? '';
  }

  Future<void> getStates() async {
    try {
      final data = await PartyMasterRepo.getStates();
      stateList.assignAll(data);
      stateNames.assignAll(data.map((e) => e.value));
    } catch (_) {}
  }

  void onStateSelected(String? state) {
    selectedState.value = state ?? '';
  }

  final PartyMasterEntryController partyMasterEntryController =
      Get.find<PartyMasterEntryController>();

  Future<void> savePartyMaster() async {
    isLoading.value = true;
    try {
      var response = await PartyMasterRepo.savePartyMaster(
        pCode: isEditMode.value ? currentPCode.value : '',
        accountName: accountNameController.text,
        printName: printNameController.text,
        location: selectedLocation.value,
        addressLine1: addressLine1Controller.text,
        addressLine2: addressLine2Controller.text,
        addressLine3: addressLine3Controller.text,
        city: selectedCity.value,
        state: selectedState.value,
        pinCode: pinCodeController.text,
        personName: personNameController.text,
        phone1: phone1Controller.text,
        phone2: phone2Controller.text,
        mobile: mobileController.text,
        gstNumber: gstNumberController.text,
        panNumber: panNumberController.text,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.back();
        showSuccessSnackbar('Success', message);
        partyMasterEntryController.getPartyList();
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
    accountNameController.clear();
    printNameController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    addressLine3Controller.clear();
    pinCodeController.clear();
    personNameController.clear();
    phone1Controller.clear();
    phone2Controller.clear();
    mobileController.clear();
    gstNumberController.clear();
    panNumberController.clear();

    selectedLocation.value = '';
    selectedCity.value = '';
    selectedState.value = '';

    isEditMode.value = false;
    currentPCode.value = '';
  }
}
