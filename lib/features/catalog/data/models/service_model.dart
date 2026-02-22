import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.durationMinutes,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      durationMinutes: json['duration_minutes'] ?? 30, // افتراضي 30 دقيقة
    );
  }
}
