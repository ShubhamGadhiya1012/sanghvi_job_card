class ColorDm {
  final String value;

  ColorDm({required this.value});

  factory ColorDm.fromJson(Map<String, dynamic> json) {
    return ColorDm(value: json['value'] ?? '');
  }
}
