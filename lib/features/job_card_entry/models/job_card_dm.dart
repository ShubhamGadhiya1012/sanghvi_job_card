class JobCardDm {
  final String invno;
  final String date;
  final String pCode;
  final String pName;
  final String poNo;
  final String poDate;
  final String iCode;
  final String iName;
  final String orderQty;
  final String productionQty;
  final String extraInnerBox;
  final String extraOuterBox;
  final String extraTapeNos;
  final String extraOuter;
  final String remark;
  final String checked1;
  final String checked2;
  final String extraPrintedReel;
  final String nos10Packing;
  final String attachments;

  JobCardDm({
    required this.invno,
    required this.date,
    required this.pCode,
    required this.pName,
    required this.poNo,
    required this.poDate,
    required this.iCode,
    required this.iName,
    required this.orderQty,
    required this.productionQty,
    required this.extraInnerBox,
    required this.extraOuterBox,
    required this.extraTapeNos,
    required this.extraOuter,
    required this.remark,
    required this.checked1,
    required this.checked2,
    required this.extraPrintedReel,
    required this.nos10Packing,
    required this.attachments,
  });

  factory JobCardDm.fromJson(Map<String, dynamic> json) {
    return JobCardDm(
      invno: json['Invno'] ?? '',
      date: json['Date'] ?? '',
      pCode: json['PCode'] ?? '',
      pName: json['PName'] ?? '',
      poNo: json['PONo'] ?? '',
      poDate: json['PODate'] ?? '',
      iCode: json['ICode'] ?? '',
      iName: json['IName'] ?? '',
      orderQty: json['OrderQty']?.toString() ?? '',
      productionQty: json['ProductionQty']?.toString() ?? '',
      extraInnerBox: json['ExtraInnerBox'] ?? '',
      extraOuterBox: json['ExtraOuterBox'] ?? '',
      extraTapeNos: json['ExtraTapeNos'] ?? '',
      extraOuter: json['ExtraOuter'] ?? '',
      remark: json['Remark'] ?? '',
      checked1: json['Checked1'] ?? '',
      checked2: json['Checked2'] ?? '',
      extraPrintedReel: json['ExtraPrintedReel']?.toString() ?? '',
      nos10Packing: json['Nos10Packing']?.toString() ?? '',
      attachments: json['Attachments'] ?? '',
    );
  }
}
