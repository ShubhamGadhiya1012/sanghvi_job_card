class CheckedDm {
  final String value;

  CheckedDm({required this.value});

  factory CheckedDm.fromJson(Map<String, dynamic> json) {
    return CheckedDm(value: json['value'] ?? '');
  }
}
