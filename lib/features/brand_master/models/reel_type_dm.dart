class ReelTypeDm {
  final String value;

  ReelTypeDm({required this.value});

  factory ReelTypeDm.fromJson(Map<String, dynamic> json) {
    return ReelTypeDm(value: json['value'] ?? '');
  }
}
