class NosPackingDm {
  final String value;

  NosPackingDm({required this.value});

  factory NosPackingDm.fromJson(Map<String, dynamic> json) {
    return NosPackingDm(value: json['value'] ?? '');
  }
}
