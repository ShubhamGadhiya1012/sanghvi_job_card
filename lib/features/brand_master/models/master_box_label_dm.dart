class MasterBoxLabelDm {
  final String value;

  MasterBoxLabelDm({required this.value});

  factory MasterBoxLabelDm.fromJson(Map<String, dynamic> json) {
    return MasterBoxLabelDm(value: json['value'] ?? '');
  }
}
