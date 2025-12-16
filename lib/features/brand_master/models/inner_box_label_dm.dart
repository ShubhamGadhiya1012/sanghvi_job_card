class InnerBoxLabelDm {
  final String value;

  InnerBoxLabelDm({required this.value});

  factory InnerBoxLabelDm.fromJson(Map<String, dynamic> json) {
    return InnerBoxLabelDm(value: json['value'] ?? '');
  }
}
