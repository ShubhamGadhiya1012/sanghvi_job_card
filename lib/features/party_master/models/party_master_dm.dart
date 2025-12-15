class PartyMasterDm {
  final String pCode;
  final String pName;
  final String printName;
  final String location;
  final String address1;
  final String address2;
  final String address3;
  final String city;
  final String state;
  final String pinCode;
  final String peronName;
  final String phone1;
  final String phone2;
  final String mobile;
  final String gstNumber;
  final String panNumber;

  PartyMasterDm({
    required this.pCode,
    required this.pName,
    required this.printName,
    required this.location,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.peronName,
    required this.phone1,
    required this.phone2,
    required this.mobile,
    required this.gstNumber,
    required this.panNumber,
  });

  factory PartyMasterDm.fromJson(Map<String, dynamic> json) {
    return PartyMasterDm(
      pCode: json['PCode'] ?? '',
      pName: json['PName'] ?? '',
      printName: json['PrintName'] ?? '',
      location: json['Location'] ?? '',
      address1: json['Address1'] ?? '',
      address2: json['Address2'] ?? '',
      address3: json['Address3'] ?? '',
      city: json['City'] ?? '',
      state: json['State'] ?? '',
      pinCode: json['PinCode'] ?? '',
      peronName: json['PeronName'] ?? '',
      phone1: json['Phone1'] ?? '',
      phone2: json['Phone2'] ?? '',
      mobile: json['Mobile'] ?? '',
      gstNumber: json['GSTNumber'] ?? '',
      panNumber: json['PANNumber'] ?? '',
    );
  }
}
