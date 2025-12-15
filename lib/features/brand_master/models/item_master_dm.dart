class ItemMasterDm {
  final String iCode;
  final String iName;
  final String description;
  final String weightPer10Nos;
  final String reelColour;
  final String reelType;
  final String outerColour;
  final String mrp;
  final String reelPrintColour;
  final String outerPrintColour;
  final String nos10Packing;
  final String innerBoxLabel;
  final String innerBoxQty;
  final String innerBoxColour;
  final String masterBoxType;
  final String masterBoxColour;
  final String masterBoxLabel;

  ItemMasterDm({
    required this.iCode,
    required this.iName,
    required this.description,
    required this.weightPer10Nos,
    required this.reelColour,
    required this.reelType,
    required this.outerColour,
    required this.mrp,
    required this.reelPrintColour,
    required this.outerPrintColour,
    required this.nos10Packing,
    required this.innerBoxLabel,
    required this.innerBoxQty,
    required this.innerBoxColour,
    required this.masterBoxType,
    required this.masterBoxColour,
    required this.masterBoxLabel,
  });

  factory ItemMasterDm.fromJson(Map<String, dynamic> json) {
    return ItemMasterDm(
      iCode: json['ICode'] ?? '',
      iName: json['IName'] ?? '',
      description: json['Description'] ?? '',
      weightPer10Nos: json['WeightPer10Nos'] ?? '',
      reelColour: json['ReelColour'] ?? '',
      reelType: json['ReelType'] ?? '',
      outerColour: json['OuterColour'] ?? '',
      mrp: json['Mrp'] ?? '',
      reelPrintColour: json['ReelPrintColour'] ?? '',
      outerPrintColour: json['OuterPrintColour'] ?? '',
      nos10Packing: json['Nos10Packing'] ?? '',
      innerBoxLabel: json['InnerBoxLabel'] ?? '',
      innerBoxQty: json['InnerBoxQty'] ?? '',
      innerBoxColour: json['InnerBoxColour'] ?? '',
      masterBoxType: json['MasterBoxType'] ?? '',
      masterBoxColour: json['MasterBoxColour'] ?? '',
      masterBoxLabel: json['MasterBoxLabel'] ?? '',
    );
  }
}
