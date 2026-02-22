import '../../domain/entities/branch_entity.dart';

class BranchModel extends BranchEntity {
  BranchModel({required super.id, required super.name, required super.address});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      address: json['address'] ?? '', // التعامل مع القيم الفارغة
    );
  }
}
