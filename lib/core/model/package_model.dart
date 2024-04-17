class PackageModel {
  final int id;
  final DateTime? purchased;

  PackageModel({required this.id, this.purchased});

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      purchased:
          json['purchased'] == null ? null : DateTime.parse(json['purchased']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchased': purchased?.toIso8601String(),
    };
  }
}
