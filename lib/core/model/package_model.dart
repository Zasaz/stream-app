class PackageModel {
  final int id;
  final DateTime? purchased;

  PackageModel({required this.id, this.purchased});

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      purchased:
          json['purchased'] != null ? DateTime.parse(json['purchased']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchased': purchased?.toIso8601String(),
    };
  }
}
